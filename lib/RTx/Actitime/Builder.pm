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
        'active'        => {
            'sum'       => 0,
            'actuals'   => []
        },
        'inactive'      => {
            'sum'       => 0,
            'actuals'   => []
        },
        'sum'           => 0
    }
}

sub mergeTaskRecord {
    my $self = shift;
    my $part = shift;
    my $data = shift;
    
    $part->{'sum'} += $data->{'actuals'}->{'sum'};
    
    foreach my $person (@{$data->{'actuals'}->{'person'}}) {
        
    }
}

sub buildData {
    my $self = shift;
    $self->reset();
    my $ref = $self->{'connection'}->getDataArrayRef($self->getTicketId());
    
    my $tasks = {};
    
    foreach my $data(@{$ref}) {
        
        my $taskid = $self->generateTaskId($data->{'task'});
        my $config = $self->getTask($data->{'task'});
        
        if ($config) {
            $taskid = $config->{'taskid'};
        }
        
        my $record = {};
        
        if (exists($tasks->{$taskid})) {
            $record = $tasks->{$taskid}
        } else {
            $record = $self->generateTaskRecord($taskid, $data);
        }
        
        my $type = 'active';
        if ($config && $self->isInactive($config, $data->{'task'})) {
            $type = 'inactive';
        }
        
        $self->mergeTaskRecord($record->{$type}, $data);
        
        $record->{'sum'} += $data->{'actuals'}->{'sum'};
        
        $tasks->{$taskid} = $record;
    }
    
    RT->Logger->error(Dumper $tasks);
}

sub getStruct {
    my $self = shift;
    return $self->{'struct'};
}

1;