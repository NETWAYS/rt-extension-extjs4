package RT::Action::ChangeOwner;

use strict;
use warnings;
use base qw(RT::Action);
use subs qw(
    Prepare
    Commit
);

sub Prepare {
    my $self = shift;
    RT->Logger->debug(__PACKAGE__. ": Prepare");
    RT->Logger->debug(__PACKAGE__. "::Argument: ". $self->Argument());
    
    # Do not apply on unowned tickets
    if ($self->TicketObj->OwnerObj->Id == RT->Nobody->Id) {
        return;
    }
    
    return 1;
}

sub Commit {
    my $self = shift;
    RT->Logger->debug(__PACKAGE__. ": Commit");
    RT->Logger->debug(__PACKAGE__. "::Argument: ". $self->Argument());
    
    if ($self->Argument =~ m/changeowner/) {
        
        RT->Logger->debug(__PACKAGE__. "::Commit Add owner as admincc");
        
        my $owner = $self->TicketObj->OwnerObj;
        $self->TicketObj->AddWatcher(
            Type => 'AdminCc',
            PrincipalId => $owner->PrincipalId
        );
    }
    
    if ($self->Argument =~ m/nobody/) {
        
        RT->Logger->debug(__PACKAGE__. "::Commit Set owner to Nobody");
        
        $self->TicketObj->SetOwner(RT->Nobody, 'Force');
    }
    return 1;
}

1;