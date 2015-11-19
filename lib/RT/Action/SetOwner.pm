package RT::Action::SetOwner;

use strict;
use warnings;
use base qw(RT::Action);
use subs qw(
    Prepare
    Commit
    UserArgument
);

sub Prepare {
    my $self = shift;
    RT->Logger->debug(__PACKAGE__. ': PREPARE');
    
    my $userid = $self->UserArgument();
    
    RT->Logger->debug(__PACKAGE__. ': Try to load user '. $userid);
    
    my $user = undef;
    
    if ($userid eq 'RT::Nobody') {
    	$user = RT->Nobody;
    } else {
        $user = RT::User->new(RT->SystemUser);
        $user->Load($userid);
    }
    
    if ($user && $user->Id > 0) {
        RT->Logger->error(__PACKAGE__. ': Got user: '. $user->Name);
        $self->{user} = $user;
        return 1;
    } else {
        RT->Logger->error(__PACKAGE__. ': Could not load valid user!');
        return;
    }
}

sub Commit {
    my $self = shift;
    
    if (ref($self->{user}) && $self->{user}->Id()) {
        $self->TicketObj->setOwner($self->{user}->Id(), 'Force');
    }
}

sub UserArgument {
    my $self = shift;
    
    my $userid = $self->TemplateObj->Content;
    
    unless ($userid) {
    	$userid = $self->Argument;
    }
    
    return $userid;
}

1;