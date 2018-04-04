package RT::Extension::Actitime::Database;

use strict;
use Carp;
use DBI;
use Data::Dumper;

use vars qw(
    $INSTANCE
);

=item new()

Constructor of RT::Extension::Actitime::Database. Object is a singleton
with the same instance

=cut

sub new {
    my $classname = shift;
    my $type = ref $classname || $classname;

    unless (ref $INSTANCE eq 'RT::Extension::Actitime::Database') {
        $INSTANCE = bless {
            'connection'    => undef,
            'use_pool'      => 1
        }, $type;

        RT->Logger->debug('Creating new instance of '. ref($INSTANCE));
    }

    my $disable_pool = RT->Config->Get('Actitime_DisablePool');
    if (defined $disable_pool && $disable_pool eq '1') {
        $INSTANCE->{'use_pool'} = '0';
    }

    return $INSTANCE;
}

=item usePool()

Return if db object use persistence

=cut

sub usePool {
    my $self = shift;
    return $self->{'use_pool'};
}

=item isApplicable()

Returns 1 if the connection is initialized

=cut

sub isApplicable {
    my $self = shift;
    if (defined($self->{'connection'})) {
        my $rc = $self->{'connection'}->ping();
        if ($rc) {
            return 1;
        } else {
            $self->{'connection'}->disconnect();
        }
    }

    return;
}

=item doConnect()

Creates a new database connection

=cut

sub doConnect {
    my $self = shift;
    if (!$self->isApplicable()) {

        RT->Logger->debug('RT::Extension::Actitime: Create DBI connection');

        $self->{'connection'} = DBI->connect(
           RT->Config->Get('Actitime_DB_DSN'),
           RT->Config->Get('Actitime_DB_USER'),
           RT->Config->Get('Actitime_DB_PASS')
        );

        if ($self->isApplicable) {
            RT->Logger->debug('RT::Extension::Actitime: Connection to DB server successful');
        } else {
            RT->Logger->error('RT::Extension::Actitime: Connection to DB server failed: ' . DBI::errstr);
        }
    }
}

=item getConnection()
    Getter for the DBI instance
=cut

sub getConnection {
    my $self = shift;

    $self->doConnect();

    return $self->{'connection'};
}

sub getField {
    my $self = shift;
    my $type = shift;

    return RT->Config->Get('Actitime_'. $type. '_NAME');
}

sub getFieldValue {
    my $self = shift;
    my $ticketid = shift;
    my $type = shift;
    my $query = RT->Config->Get('Actitime_'. $type. '_QUERY');
    return sprintf($query, $ticketid);
}

sub getTasksStatement {
    my $self = shift;
    my $ticketid = shift;
    my $customerid = shift;

    my $type = 'PROJECT';
    my $id = $ticketid;

    if (defined($customerid) && $customerid > 0) {
        $type = 'CUSTOMER';
        $id = $customerid
    }

    my $sth_name = 'sth_tasks_'. $type;

    unless (defined($self->{$sth_name})) {
        my $query = qq{
            SELECT
                c.name as `customer`,
                p.name as `project`,
                p.id as `projectid`,
                t.name as `task`,
                t.budget as `budget`,
                t.deadline_date as `deadline`,
                t.completion_date as `completed`,
                t.id as `taskid`
            FROM task t
            INNER JOIN project p on p.id = t.project_id
            INNER JOIN customer c on c.id = t.customer_id
            WHERE p.archiving_timestamp is NULL
        };

        my $field = $self->getField($type);

        if ($field) {
            $query .= ' AND '. $field. ' LIKE ?';

            $query .= ' ORDER BY p.name_lower DESC LIMIT 50';
        } else {
            croak("Field and value not properly configured");
        }

        $self->{$sth_name} = $self->getConnection()->prepare($query);
    }

    $self->{$sth_name}->bind_param(1, $self->getFieldValue($id, $type));

    return $self->{$sth_name};
}

sub getActualsStatement {
    my $self = shift;
    my $taskid = shift;

    unless (defined ($self->{'sth_actuals'})) {

        my $query = qq{
            SELECT
                u.id as `userid`,
                u.first_name,
                u.last_name,
                sum(actuals) as actuals
            FROM tt_record r

            INNER JOIN at_user u on (u.id = r.user_id)
            WHERE r.task_id=?

            GROUP BY u.id, u.first_name, u.last_name WITH ROLLUP
        };

        $self->{'sth_actuals'} = $self->getConnection()->prepare($query);
    }

    $self->{'sth_actuals'}->bind_param(1, $taskid);

    return $self->{'sth_actuals'};
}

sub getActuals {
    my $self = shift;
    my $taskid = shift;

    my $struct = {
        'sum'       => 0,
        'people'    => []
    };

    my $actuals = $self->getActualsStatement($taskid);
    $actuals->execute();

    while (my $row = $actuals->fetchrow_hashref()) {
        if ($row->{'first_name'} && $row->{'last_name'} && $row->{'userid'}) {
            push(@{ $struct->{'people'} }, {
                'name' => sprintf('%s, %s',
                    $row->{'last_name'}, $row->{'first_name'}),
                'userid' => $row->{'userid'}+0,
                'actuals' => $row->{'actuals'}+0
            });
        } else {
            $struct->{'sum'} = $row->{'actuals'}+0;
        }
    }

    return $struct;
}

sub getDataArrayRef {
    my $self = shift;
    my $ticketid = shift;
    my $customerid = shift;

    my $tasks = $self->getTasksStatement($ticketid, $customerid);
    $tasks->execute();

    my(@data);

    while(my $row = $tasks->fetchrow_hashref()) {

        unless ($row->{'budget'}) {
            $row->{'budget'} = 0;
        }

        $row->{'budget'} = $row->{'budget'} + 0;

        $row->{'taskid'} = $row->{taskid} + 0;

        $row->{'actuals'} = $self->getActuals($row->{'taskid'});

        push(@data, $row);
    }



    return \@data;
}

1;