package RT::Action::Pretix;

use base 'RT::Action';

use strict;
use warnings;

use RT::Extension::PretixApi::Data;
use Text::Template;

our $CHILD_SUBJECT_FORMAT = RT->Config->Get('PretixAttendee_Subject_Format') //
    'Attendee for {$event}, order {$order} | {$name}';

our $CHILD_SUBJECT_TEMPLATE = Text::Template->new(
    TYPE => 'STRING',
    SOURCE => $CHILD_SUBJECT_FORMAT
);

our $TOP_SUBJECT_FORMAT = RT->Config->Get('PretixTop_Subject_Format') //
    'Order has been placed {$order} for {$event} | {$name}';

our $TOP_SUBJECT_TEMPLATE = Text::Template->new(
    TYPE => 'STRING',
    SOURCE => $TOP_SUBJECT_FORMAT
);

sub _process_ticket_data {
    my $self = shift;
    my $config = shift;
    my $ticket = shift;
    my $values_ref = shift;

    my %values = %{$values_ref};

    while (my ($field, $action) = each(%{$config})) {
        if (exists $values{$field}) {
            my ($context, $target) = split(/\./, $action, 2);
            $context = lc($context);
            my $value = $values{$field};

            unless ($value) {
                RT->Logger->info(
                    sprintf('Pretix: Value is empty, ommit (action=%s, field=%s)',
                        $action, $field)
                );
                next;
            }

            # Add customfields to tickets
            if ($context eq 'cf') {

                my ($id, $msg) = $ticket->AddCustomFieldValue(
                    Field => $target,
                    Value => $value
                );

                if ($id == 0) {
                    RT->Logger->error(
                        sprintf('Pretix: Error adding value "%s" to CustomField "%s" (error=%s)',
                            $value, $target, $msg)
                    );
                } else {
                    RT->Logger->debug(
                        sprintf('Pretix: Add value "%s" to CustomField "%s" (id=%d)',
                            $value, $target, $id)
                    );
                }
            }
            elsif($context eq 'ticket') {
                $target = lc($target);
                if ($target eq 'requestor') {
                    # Remove origin requestor first, because this is Pretix itself
                    foreach my $email($self->TicketObj->RoleGroup('Requestor')->MemberEmailAddresses()) {
                        $ticket->DeleteWatcher(
                            Type  => 'Requestor',
                            Email => $email
                        );

                        RT->Logger->debug(sprintf('Pretix: Delete requestor %s', $email));
                    }

                    my ($id, $msg) = $ticket->AddWatcher(
                        Type  => 'Requestor',
                        Email => $value
                    );

                    RT->Logger->debug(sprintf('Pretix: Add requestor %s (%d, %s)', $value, $id, $msg));
                }
            }
        }
    }
}

sub Describe  {
    my $self = shift;
    return (ref $self . " adds Pretix information to tickets or create new tickets for attendees.");
}

sub Prepare  {
    my $self = shift;
    my $config = undef;

    {
        eval { $config = eval $self->TemplateObj->Content . ';' };

        if ($!) {
            RT->Logger->error('Pretix: Template is not perl formatted: ' . $!);
            return 0;
        }
    }

    unless (ref $config eq 'HASH') {
        $self->TicketObj->Comment(Content =>
            sprintf('Pretix: Please check your template: %s/Admin/Global/Template.html?Queue=0&Template=%d',
                RT->Config->Get('WebBaseURL'),
                $self->TemplateObj->id
            )
        );
        RT->Logger->error(sprintf('Pretix: Template contains errors. Please check id=%d', $self->TemplateObj->id));
        return 0;
    }

    my $api = RT::Extension::PretixApi::Data->new();

    if ($self->TicketObj->Subject =~ m/order has been placed: ([\w\d]{5})/i) {
        my $order_code = $1;

        RT->Logger->info('Pretix: Got order mail (' . $order_code . ')');

        my $top_processed = 0;
        my $subject_processed = 0;
        my $attachments = $self->TicketObj->Attachments();

        while (my $attachment = $attachments->Next()) {
            if ($attachment->ContentType eq 'text/plain') {
                if ($attachment->Content =~ m/https?:\/\/[^\/]+\/control\/event\/([^\/]+)\/([^\/]+)\/orders\/$order_code/) {
                    my $organizer = $1;
                    my $event = $2;

                    RT->Logger->info(sprintf('Pretix: organizer=%s, event=%s, order=%s', $organizer, $event, $order_code));

                    my $data = $api->get_order($organizer, $event, $order_code);

                    my @positions = @{ $data->{positions} };
                    my $count_positions = scalar @positions;

                    RT->Logger->info(sprintf('Pretix: Got %d positions (attendees)', $count_positions));

                    foreach my $position (@positions) {

                        # Copy one position into the main order data
                        # that we have only one level
                        my %values = %{ $data };
                        delete $values{'positions'};
                        %values = ( %values, %{ $position } );

                        unless ($subject_processed) {
                            $self->TicketObj->SetSubject($TOP_SUBJECT_TEMPLATE->fill_in(HASH => \%values));
                            $subject_processed = 1;
                        }

                        # If we have only one position (equals to one attendee) we use the base ticket
                        my $ticket = undef;
                        if ($count_positions == 1) {
                            $ticket = $self->TicketObj;

                        # If we have more than one position, we create child tickets for the attendees
                        } else {
                            # Because we do not have the top ticket processed
                            unless ($top_processed) {
                                my %tmp_values = %{ $data };
                                delete $tmp_values{'positions'};
                                $self->_process_ticket_data($config, $self->TicketObj, \%tmp_values);
                                $top_processed = 1;
                            }

                            $ticket = RT::Ticket->new(RT->SystemUser);

                            my $mime = $self->TransactionObj->Attachments->First->ContentAsMIME(Children => 1);

                            my ($id, $transaction, $msg) = $ticket->Create(
                                Queue      => $self->TicketObj->Queue,
                                Subject    => $CHILD_SUBJECT_TEMPLATE->fill_in(HASH => \%values),
                                RefersTo   => [$self->TicketObj->id],
                                MIMEObj    => $mime
                            );

                            RT->Logger->debug(sprintf('Pretix: Created ticket %d (%s)', $ticket->id, $ticket->Subject));
                        }

                        $self->_process_ticket_data($config, $ticket, \%values);
                    }

                    last;
                }
            }
        }
    }

    return 1;
}

sub Commit {
    my $self = shift;
    return 1;

}

RT::Base->_ImportOverlays();

1;
