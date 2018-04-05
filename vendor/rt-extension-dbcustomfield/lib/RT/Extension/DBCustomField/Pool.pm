package RT::Extension::DBCustomField::Pool;

use strict;
use Data::Dumper;
use DBI;
use DBI::Const::GetInfoType;
use version '1.0';

sub new {
	my $classname = shift;
	my $type = ref $classname || $classname;
	return bless {
		'connections'		=> {},
		'configurations'	=> {},
		'use_pool'			=> 1
	}, $type;
}

sub validConnection {
	my $self = shift;
	my $name = shift;
	if (exists($self->{'connections'}->{$name}) && $self->{'connections'}->{$name}->ping) {
		return 1;
	}
	return;
}

sub validConfiguration {
	my $self = shift;
	my $name = shift;
	return exists($self->{'configurations'}->{$name});
}

sub getConfiguration {
	my $self = shift;
	my $name = shift;
	return $self->{'configurations'}->{$name};
}

sub getConnection {
	my $self = shift;
	my $name = shift;

	my ($dbh);

	if ($self->validConfiguration($name)) {
		RT->Logger->info('Acquire connection: '. $name);

		if (! $self->validConnection($name)) {
			RT->Logger->info('Creating new: '. $name);
			my $c = $self->getConfiguration($name);
			$dbh = DBI->connect($c->{'dsn'}, $c->{'username'}, $c->{'password'});

			my $rc = $dbh->ping();
			if ($rc) {
				RT->Logger->info("Connection $name successfully pinged");

				my $version = $dbh->get_info($GetInfoType{SQL_DBMS_VER});
				if ($version) {
					RT->Logger->info("$name is a $version");

					if ($self->{'use_pool'}) {
						$self->{'connections'}->{$name} = $dbh;
					}
				} else {
					undef($dbh);
				}
			}
		}

		if ($self->{use_pool}) {
			return $self->{'connections'}->{$name};
		}

		return $dbh;
	} else {
		RT->Logger->crit("Invalid connection configuration for '$name'.");
	}
}

sub usePool {
	my $self = shift;
	return $self->{'use_pool'};
}

sub init {
	my $self = shift;

	RT->Logger->info('Init connections');

	my $c = RT->Config->Get('DBCustomField_Connections');

	my $disable_pool = RT->Config->Get('DBCustomField_DisablePool');

	if (defined $disable_pool && $disable_pool eq '1') {
		RT->Logger->info('Connection pooling is disabled');
		$self->{'use_pool'} = 0;
	}

	for my $name (keys(%{$c})) {
		my $config = $c->{$name};
		$self->{'configurations'}->{$name} = $config;

		if (exists($config->{'autoconnect'}) && $config->{'autoconnect'} eq 1 && $self->{'use_pool'}) {
			$self->getConnection($name);
		}
	}
}

1;
