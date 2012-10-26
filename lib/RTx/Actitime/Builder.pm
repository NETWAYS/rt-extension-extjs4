package RTx::Actitime::Builder;

use strict;
use version;
use Data::Dumper;

our $VERSION = '0.0.1';

sub new {
    my $classname = shift;
    my $type = ref $classname || $classname;
    
    my $obj = bless {
        'ticketid'          => undef,
        'customerid'        => undef,
        'struct'            => {},
        'tasks'             => {},
        'connection'        => shift,
        'show_all'
            => RT->Config->Get('RTx_Actitime_TASK_SHOW_ALL') || 0,
        'budget_warning_percent'
            => RT->Config->Get('RTx_Actitime_BUDGET_WARNING_PERCENT') || 100,
        'budget_critical_percent'
            => RT->Config->Get('RTx_Actitime_BUDGET_CRITICAL_PERCENT') || 100,
    }, $type;
    
    $obj->getTasks();
    
    return $obj;
}

sub generateTaskId {
    my $self = shift;
    my $taskid = shift;
    $taskid =~ s/\s/_/g;
    $taskid = lc($taskid);
    return $taskid;
}

sub getTasks() {
    my $self = shift;
    
    my $tasks = RT->Config->Get('RTx_Actitime_TASK_CONFIGURATION') || [];
    
    foreach my $task(@{ $tasks }) {
        my $struct = {};
        
        my $taskid = $self->generateTaskId($task->{'name'});
        
        my $match = '^('. join('|',@{ $task->{'active'} }). ')$';
        $struct->{'match_active'} = qr{$match};
        
        $match = '^('. join('|',@{ $task->{'inactive'} }). ')$';
        $struct->{'match_inactive'} = qr{$match};
        
        $match = '^('. join('|',(@{ $task->{'inactive'} }, @{ $task->{'active'} })). ')$';
        $struct->{'match_all'} = qr{$match};
        
        $struct->{'taskid'} = $taskid;
        
        $struct->{'taskname'} = $task->{'name'};
        
        $struct->{'budget_warning_percent'} = 
            exists($task->{'budget_warning_percent'}) ?
            $task->{'budget_warning_percent'} :
            $self->{'budget_warning_percent'};
        
        $struct->{'budget_critical_percent'} = 
            exists($task->{'budget_critical_percent'}) ?
            $task->{'budget_critical_percent'} :
            $self->{'budget_critical_percent'};
       
       $self->{'tasks'}->{$taskid} = $struct;
    }
}

sub setTicketId {
    my $self = shift;
    my $ticketid = shift;
    $self->{'ticketid'} = $ticketid;
}

sub getTicketId {
    my $self = shift;
    return $self->{'ticketid'};
}

sub setCustomerId {
    my $self = shift;
    my $customerid = shift;
    $self->{'customerid'} = $customerid;
}

sub getCustomerId {
    my $self = shift;
    return $self->{'customerid'};
}

sub reset {
    my $self = shift;
    $self->{'struct'} = {};
}

sub getTask {
    my $self = shift;
    my $task_name = shift;
    
    foreach my $taskid (keys (%{ $self->{'tasks'} })) {
        my $task = $self->{'tasks'}->{$taskid};
        $task_name = lc($task_name);
        if ($task_name =~ m/$task->{'match_all'}/) {
            return $task;
        }
    }
    
    return;
}

sub isInactive {
    my $self = shift;
    my $task = shift;
    my $name = shift;
    
    if ($name =~ /$task->{'match_inactive'}/) {
        return 1;
    }
    
    return;
}

sub isActive {
    my $self = shift;
    my $task = shift;
    my $name = shift;
    
    if ($name =~ /$task->{'match_active'}/) {
        return 1;
    }
    
    return;
}

sub generateTaskRecord {
    my $self = shift;
    my $taskid = shift;
    my $data = shift;
    
    return {
        'taskid'        => $taskid,
        'project'       => $data->{'project'},
        'task'          => $data->{'task'},
        'labels'        => [],
        'active'        => {
            'sum'       => 0,
            'budget'    => 0,
            'labels'    => []
        },
        'inactive'      => {
            'sum'       => 0,
            'budget'    => 0,
            'labels'    => []
        },
        'tasks'         => [],
        'sum'           => 0
    }
}

sub mergeTaskRecord {
    my $self = shift;
    my $part = shift;
    my $data = shift;
    
    $part->{'sum'} += $data->{'sum'};
    $part->{'budget'} += $data->{'budget'};
    
    push(@{$part->{'labels'}}, $data->{'task'});
}

sub normalizeDataRecord {
    my $self = shift;
    my $data = shift;
    
    my %hash = %{ $data }; # DEREF
    
    $hash{'people'} = $hash{'actuals'}{'people'};
    delete($hash{'actuals'}{'people'});
    
    $hash{'sum'} = $hash{'actuals'}{'sum'};
    delete($hash{'actuals'}{'sum'});
    
    delete($hash{'actuals'});
    
    return \%hash;
}

sub buildData {
    my $self = shift;
    $self->reset();
    my $ref = $self->{'connection'}->getDataArrayRef(
        $self->getTicketId(),
        $self->getCustomerId()
    );
    
    my $tasks = {
        'success'   => scalar(@{ $ref }) ? 1 : 0,
        'ticket'    => $self->getTicketId(),
        'customer'  => $self->getCustomerId(),
        'type'      => defined($self->getCustomerId()) ? 'CUSTOMER' : 'PROJECT',
        'tasks'     => []
    };
    
    foreach my $data(@{$ref}) {
        
        my $taskid = $self->generateTaskId($data->{'task'});
        my $name  = $data->{'task'};
        my $config = $self->getTask($data->{'task'});
        
        if ($config) {
            $taskid = $config->{'taskid'};
            $name = $config->{'taskname'};
        }
        
        my $record = {};
        
        if (grep($_->{'taskid_str'} eq $taskid, @{ $tasks->{'tasks'} })) {
            my @test = grep($_->{'taskid_str'} eq $taskid, @{ $tasks->{'tasks'} });
            $record = $test[0];
        } else {
            $record = $self->generateTaskRecord($taskid, $data);
            push(@{$tasks->{'tasks'}}, $record);
        }
        
        my $type = 'active';
        if ($config && $self->isInactive($config, $data->{'task'})) {
            $type = 'inactive';
        }
        
        $data = $self->normalizeDataRecord($data);
        
        push(@{$record->{'tasks'}}, $data);
        
        $self->mergeTaskRecord($record->{$type}, $data);
        
        $record->{'sum'} += $data->{'sum'};
        
        $record->{'taskid_str'} = $taskid;
        
        $record->{'taskname'} = $name;
        
        push(@{ $record->{'labels'} }, $data->{'task'});

    }
    
    $self->{'struct'} = $tasks;
}

sub getStruct {
    my $self = shift;
    return $self->{'struct'};
}

1;