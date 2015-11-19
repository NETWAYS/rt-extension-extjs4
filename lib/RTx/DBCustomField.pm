package RTx::DBCustomField;

use strict;
use version;
use 5.010;

our $VERSION="1.0.0";

use RTx::DBCustomField::Pool;
use utf8;
use Data::Dumper;

use vars qw(
	$INSTANCE
);

sub new {
	my $classname = shift;
	my $type = ref $classname || $classname;
	
	unless (ref $INSTANCE eq 'RTx::DBCustomField') {
		$INSTANCE = bless {
			'pool'	=> RTx::DBCustomField::Pool->new()
		}, $type;
		
		RT->Logger->info('Creating new instance of '. ref($INSTANCE));
		
		$INSTANCE->{pool}->init();
	}
	
	return $INSTANCE;
}

sub getQueryHash {
	return getConfigByName(@_);
}

sub getConfigByName {
	my $self = shift;
	my $name = shift;
	
	if (exists (RT->Config->Get('RTx_DBCustomField_Queries')->{$name})) {
		return RT->Config->Get('RTx_DBCustomField_Queries')->{$name};
	}
	
	return undef;
}

sub getConfigByCustomFieldName {
	my $self = shift;
	my $name = shift;
	
	if (exists(RT->Config->Get('RTx_DBCustomField_Fields')->{$name})) {
		my $id = RT->Config->Get('RTx_DBCustomField_Fields')->{$name};
		return ($id, RT->Config->Get('RTx_DBCustomField_Queries')->{$id});
	}
}

sub getQueries {
	my $self = shift;
	
	my $c = RT->Config->Get('RTx_DBCustomField_Queries');
	if (ref($c) eq 'HASH') {
		return $c;
	}
	
	return {};
}

sub getConfigByCustomField {
	my $self = shift;
	my $cf = shift;
	my $id = undef;
	
	if (exists(RT->Config->Get('RTx_DBCustomField_Fields')->{$cf->Name})) {
		$id = RT->Config->Get('RTx_DBCustomField_Fields')->{$cf->Name};
	}
	elsif (exists(RT->Config->Get('RTx_DBCustomField_Fields')->{$cf->Id})) {
		$id = RT->Config->Get('RTx_DBCustomField_Fields')->{$cf->Id};
	}
	
	if ($id) {
		return ($id, RT->Config->Get('RTx_DBCustomField_Queries')->{$id});
	}
}

sub getReturnValue {
	my $self = shift;
	my $name = shift;
	my $value = shift;
	my $object = shift;
	
	return undef unless($value);
	
	if ((my $qref = $self->getQueryHash($name))) {
		if ((my $c = $self->{pool}->getConnection($qref->{'connection'}))) {
			
			my $query = $self->substituteQuery(
				query	=> $qref->{'returnquery'},
				fields	=> $qref->{'returnfields'},
				idfield	=> $qref->{'returnfield_id'},
				value	=> $value,
				ticket	=> $object
			);

			
			my $sth = $c->prepare($query);
			
			if ($query =~ /\?/) {
				$sth->bind_param(1, $value || 'INVALID');
			}
		
			RT->Logger->info("ReturnQuery ($name, ID=$value): $query");
	
			my $re = $sth->execute();
			
			my $ref = $sth->fetchrow_hashref();

			if (! $self->{'pool'}->usePool) {
				$sth->finish() if ($sth);
				$c->disconnect();
			}

			return unless ($ref);
			return $self->convertHashToUtf8($ref);
		}
	}
	
	return undef;
}

sub getReturnValueSmall {
	my $self = shift;
	my $name = shift;
	my $value = shift;
	my $object = shift;
	my $id = undef;
	
	my $qref = undef;
	if (ref($name) eq 'RT::CustomField') {
		($id, $qref) = $self->getConfigByCustomField($name);
	} else {
		$qref = $self->getQueryHash($name);
		$id = $name;
	}
	
	if ($qref && $id) {
		my $row = $self->getReturnValue($id, $value, $object);
		return unless($row);
		return $self->wrapHash($row, $qref->{'returnfield_small_tpl'});
	}
	
}

sub getFields {
	my $self = shift;
	my ($fields, $idfield) = @_;
	
}

sub wrapHash {
	my $self = shift;
	my $row = shift;
	my $format = shift;
	return unless ($row);
	$format =~ s/\{([^\}]+)\}/$row->{$1}/ge;
	return $format;
}

sub substituteQuery {
	my $self = shift;
	my $h = {
		fields	=> {},
		idfield	=> undef,
		query	=> undef,
		where	=> undef,
		ticket	=> undef,
		value	=> undef,
		@_
	};
	
	my $query = $h->{'query'};
	
	my (@fields, $f_string);
	while (my($f_alias,$f_id) = each(%{ $h->{'fields'} })) {
		# push @fields, sprintf('%s AS %s', $f_id, $f_alias);
		push @fields, sprintf('%s AS %s', $f_id, $f_alias);
		push @fields, "$f_id";
	}
	
	if ($h->{'idfield'}) {
		push @fields, sprintf('%s as __dbcf_idfield__', $h->{'idfield'})
	}
	
	$f_string = join(', ', @fields);
	$query =~ s/__DBCF_FIELDS__/$f_string/g;
	
	if ($h->{'where'}) {
		$query =~ s/__DBCF_AND_WHERE__/ and $h->{'where'}/g;
		$query =~ s/__DBCF_WHERE__/$h->{'where'}/g;
	} else {
		$query =~ s/__DBCF_AND_WHERE__//g;
		$query =~ s/__DBCF_WHERE__//g;
	}
	
	if (ref($h->{'ticket'}) eq 'RT::Ticket') {
		my $t = $h->{'ticket'};
		
		$query =~ s/__TICKET\(([^\)]+)\)__/$t->$1/ge;
		$query =~ s/__TICKET__/$t->Id/g;
	}
	
	if (exists($h->{'value'}) && $h->{'value'}) {
		$query =~ s/__VALUE__/$h->{'value'}/g;
	}
	
	return $query
} 

sub callQuery {
	my $self = shift;
	
	my $ARGRef = {
		name => undef,
		query => undef,
		ticket => undef,
		@_
	};
	
	my $name = $ARGRef->{'name'};
	my $q = $ARGRef->{'query'};
	my $ticket = $ARGRef->{'ticket'};
	
	RT->Logger->info("NAME: $name, q: $q, TICKET: $ticket");
	
	if ((my $qref = $self->getQueryHash($name))) {
		if ((my $c = $self->{pool}->getConnection($qref->{'connection'}))) {
			
			my $query = $qref->{'query'};

			my $sth = undef;
			
			if (ref $qref->{'searchfields'} eq 'ARRAY' && $q) {
				
				my (@parts, $where);
				
				foreach my $sf (@{ $qref->{'searchfields'} }) {
					push @parts, sprintf('%s LIKE ?', $sf);
				}
				
				$where = join(' '. ($qref->{'searchop'} || 'OR'). ' ', @parts);
				
				$query = $self->substituteQuery(
					fields	=> $qref->{'fields'},
					idfield	=> $qref->{'field_id'},
					query	=> $query,
					where	=> $where,
					ticket	=> $ticket
				);
				
				$sth = $c->prepare($query);
				
				RT->Logger->info("callQuery ($name, QueryVal=$q): $query");
				
				for(my $i=1; $i<=scalar @parts; $i++) {
					my $qarg = $q. '%';
					$qarg =~ s/\*/%/g;
					$sth->bind_param($i, $qarg);
				}
			}
			else {
				$query = $self->substituteQuery(
					fields	=> $qref->{'fields'},
					idfield	=> $qref->{'field_id'},
					query	=> $query,
					ticket	=> $ticket
				);
				
				$sth = $c->prepare($query);
			}
			
			my $re = $sth->execute();
			
			if (!$re && $c->errstr()) {
				die ($query. '<br /><br />'. $c->errstr())
			}
			
			my (@out);
			
			while (my $row = $sth->fetchrow_hashref) {
				push @out, $self->convertHashToUtf8($row);
			}

			if (! $self->{'pool'}->usePool) {
				$sth->finish() if ($sth);
				$c->disconnect();
			}
			
			return \@out;
		}
	}
}

sub convertHashToUtf8 {
	my $self = shift;
	my $ref = shift;
	
	if (exists($ref->{'__dbcf_idfield__'})) {
		$ref->{'id'} = $ref->{'__dbcf_idfield__'};
		delete($ref->{'__dbcf_idfield__'});
	}
	
	foreach (keys %{ $ref }) {
		utf8::decode($ref->{$_});
	}
	return $ref;
}

RTx::DBCustomField->new();
1;
=pod

=head1 NAME

RTx::DBCustomField

=head1 VERSION

version 1.0.0

=head1 AUTHOR

Marius Hein <marius.hein@netways.de>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by NETWAYS GmbH <info@netways.de>

This is free software, licensed under:
    GPL Version 2, June 1991

=cut

__END__
