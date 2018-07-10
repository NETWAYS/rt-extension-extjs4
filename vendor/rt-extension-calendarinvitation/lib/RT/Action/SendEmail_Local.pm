use strict;
no warnings qw(redefine);

package RT::Action::SendEmail;

sub AttachableFromTransaction {
    my $txn = shift;

    my $attachments = RT::Attachments->new( RT->SystemUser );

    $attachments->Limit(
        FIELD => 'TransactionId',
        VALUE => $txn->Id,
    );

    # Don't attach anything blank
    $attachments->OrderBy( FIELD => 'id' );

    # We want to make sure that we don't include the attachment that's
    # being used as the "Content" of this message" unless that attachment's
    # content type is not like text/...
    my $transaction_content_obj = $txn->ContentObj;
    $attachments->LimitNotEmpty;

    if (   $transaction_content_obj
        && $transaction_content_obj->ContentType =~ m{text/}i )
    {
        # If this was part of a multipart/alternative, skip all of the kids
        my $parent = $transaction_content_obj->ParentObj;
        if ($parent and $parent->Id and $parent->ContentType eq "multipart/alternative") {
            $attachments->Limit(
                ENTRYAGGREGATOR => 'AND',
                FIELD           => 'parent',
                OPERATOR        => '!=',
                VALUE           => $parent->Id,
            );
        } else {
            $attachments->Limit(
                ENTRYAGGREGATOR => 'AND',
                FIELD           => 'id',
                OPERATOR        => '!=',
                VALUE           => $transaction_content_obj->Id,
            );
        }
    }


    my $cal = RT::Attachments->new( RT->SystemUser );
    $cal->Limit(
        FIELD => 'ContentType',
        VALUE => 'text/calendar',
        ENTRYAGGREGATOR => 'OR',
        ALIAS => 'main',
        SUBCLAUSE => 'ZZ'
    );
    $cal->Limit(
        FIELD => 'TransactionId',
        VALUE => $txn->Id,
    );

    use DBIx::SearchBuilder::Union;
    my $union = DBIx::SearchBuilder::Union->new();
    $union->add($attachments);
    $union->add($cal);
    return $union;
}

1;