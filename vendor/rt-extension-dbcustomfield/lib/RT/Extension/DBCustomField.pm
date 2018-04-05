package RT::Extension::DBCustomField;

use strict;
use version;
use v5.10.1;

our $VERSION='2.0.0';

RT->AddJavaScript('dbcustomfield.js');
RT->AddStyleSheets('dbcustomfield.css');

use RT::Extension::DBCustomField::Pool;
use utf8;
use Data::Dumper;

use vars qw(
	$INSTANCE
);

sub new {
	my $classname = shift;
	my $type = ref $classname || $classname;

	unless (ref $INSTANCE eq 'RT::Extension::DBCustomField') {
		$INSTANCE = bless {
			'pool'	=> RT::Extension::DBCustomField::Pool->new()
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

	if (exists (RT->Config->Get('DBCustomField_Queries')->{$name})) {
		return RT->Config->Get('DBCustomField_Queries')->{$name};
	}

	return undef;
}

sub getConfigByCustomFieldName {
	my $self = shift;
	my $name = shift;

	if (exists(RT->Config->Get('DBCustomField_Fields')->{$name})) {
		my $id = RT->Config->Get('DBCustomField_Fields')->{$name};
		return ($id, RT->Config->Get('DBCustomField_Queries')->{$id});
	}
}

sub getQueries {
	my $self = shift;

	my $c = RT->Config->Get('DBCustomField_Queries');
	if (ref($c) eq 'HASH') {
		return $c;
	}

	return {};
}

sub getConfigByCustomField {
	my $self = shift;
	my $cf = shift;
	my $id = undef;

	if (exists(RT->Config->Get('DBCustomField_Fields')->{$cf->Name})) {
		$id = RT->Config->Get('DBCustomField_Fields')->{$cf->Name};
	}
	elsif (exists(RT->Config->Get('DBCustomField_Fields')->{$cf->Id})) {
		$id = RT->Config->Get('DBCustomField_Fields')->{$cf->Id};
	}

	if ($id) {
		return ($id, RT->Config->Get('DBCustomField_Queries')->{$id});
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
				query	=> $qref->{'display_value'},
				value   => $value,
				ticket	=> $object
			);

			my $sth = $c->prepare($query);

			if ($query =~ /\?/) {
				$sth->bind_param(1, $value || 'INVALID');
			}

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
		return $self->wrapHash($row, $qref->{'display_value_tpl'} || '{field_value}');
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
		query	=> undef,
		value   => undef,
		ticket	=> undef,
		@_
	};

	my $query = $h->{'query'};

	if (ref($h->{'ticket'}) eq 'RT::Ticket') {
		my $ticketId = $h->{'ticket'}->Id;
		$query =~ s/__TICKET__/$ticketId/g;
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

	if ((my $qref = $self->getQueryHash($name))) {
		if ((my $c = $self->{pool}->getConnection($qref->{'connection'}))) {

			my $query = $self->substituteQuery(
				query	=> $qref->{'suggestions'},
				ticket	=> $ticket
			);

			my $sth = $c->prepare($query);

			my $questionMarkNo = 0;
			while ($query =~ /((?:LIKE\s+?\?)|(?:(?<!LIKE)\s*?\?))/gi) {
				if (substr(lc($1), 0, 4) eq 'like') {
					$sth->bind_param(++$questionMarkNo, $q . '%');
				} else {
					$sth->bind_param(++$questionMarkNo, $q);
				}
			}

			my $re = $sth->execute();

			if (!$re && $c->errstr()) {
				die ($query. '<br /><br />'. $c->errstr())
			}

			my (@out, $count);
			my $limit = RT->Config->Get('DBCustomField_Suggestion_Limit') || 10;

			while (my $row = $sth->fetchrow_hashref) {
				my $dataRow = $self->convertHashToUtf8($row);
				if (!exists($dataRow->{'field_value'})) {
					RT->Logger->error(
						'Column "field_value" missing in result. Does the "' . $name . '" query return one?'
					);
					last;
				} elsif (!$dataRow->{'field_value'}) {
					RT->Logger->warning('Column "field_value" empty in result. Enable debug log for more details.');
					RT->Logger->debug('Result row was: ' . Dumper($dataRow));
				} else {
					push @out, $dataRow;
					if (++$count == $limit) {
						last;
					}
				}
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

RT::Extension::DBCustomField->new();
1;
=pod

=head1 NAME

RT::Extension::DBCustomField - Link custom field values with external sources

=head1 DESCRIPTION

This extension allows to link custom field values to external databases.

Specific custom field types provided by this extension allow users to choose from a list of suggestions what they
want to associate with a ticket. This works with the help of auto-completion which is invoked once a user typed
two or more characters.

Stored and displayed is by default what the user chose. However, by configuring custom templates it is possible
to change what is displayed to the user. This applies to the list of suggestions as well as to the actual value
users will see when viewing the ticket.

Pleaes note that what is displayed to the user is not necessarily what is internally stored by RT for the custom
field. Any time a ticket is viewed by a user the extension fetches what to display from the external database.
This way it is possible to e.g. only store a primary key value and display just an associated name to users.

=head1 RT VERSION

Works with RT 4.4.2

=head1 REQUIREMENTS

=over

=item DBI (>= 1.37)

=back

As well as an appropriate driver for the databases you want to integrate. (e.g. C<DBD::mysql> for MySQL)

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::DBCustomField');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 CONFIGURATION

First you need to define C<$DBCustomField_Connections> which is a hash of available database connections.

	Set($DBCustomField_Connections, {
		'sugarcrm' => {
			'dsn' => 'DBI:mysql:database=SUGARCRMDB;host=MYHOST;port=3306;mysql_enable_utf8=1',
			'username' => 'USER',
			'password' => 'PASS'
		}
	});

Then it is required to define C<$DBCustomField_Queries> which is a hash of available query definitions.
Every query definition has a name and consists of two queries. One for the auto-completion suggestions
and one to fetch display values with.

	Set ($DBCustomField_Queries, {
		'companies' => {
			# The connection to use
			'connection' => 'sugarcrm',

			# The query to fetch auto-completion suggestions with. `field_value' is mandatory
			# and any occurrence of `?' is replaced with a user's input.
			'suggestions' => q{
				SELECT
				cstm.net_global_id_c AS field_value, cstm.shortname_c AS shortname, a.name
				FROM accounts a
				INNER JOIN accounts_cstm cstm ON cstm.id_c = a.id AND cstm.net_global_id_c
				WHERE a.deleted = 0 AND (cstm.net_global_id_c = ? OR cstm.shortname_c LIKE ? OR a.name LIKE ?)
				ORDER BY shortname
			},

			# The display template to use for each entry returned by the suggestions query. To reference specific
			# columns here encapsulate their name with curly braces. The default is just `{field_value}'
			# HTML support: Yes
			'suggestions_tpl' => q{
				<div>
					<strong>{shortname}</strong>
					<div>{name} (<strong>{field_value}</strong>)</div>
				</div>
			},

			# The query to fetch display values with. `field_value' is only required when not defining
			# a custom display template. A single occurrence of `?' is replaced with the value internally
			# stored by RT.
			'display_value' => q{
				SELECT
				cstm.net_global_id_c AS field_value, cstm.shortname_c AS shortname
				FROM accounts a
				INNER JOIN accounts_cstm cstm ON cstm.id_c = a.id AND cstm.net_global_id_c
				WHERE cstm.net_global_id_c = ?
			},

			# The display template to use when showing the custom field value to users. To reference specific
			# columns here encapsulate their name with curly braces. The default is just `{field_value}'.
			# HTML support: Yes, but try to avoid manipulating the layout too much (e.g. with block elements)
			'display_value_tpl' => '{shortname} (<i>{field_value}</i>)'
		},
	});

Last you need to define C<$DBCustomField_Fields> which maps query definitions to specific custom fields.
This controls which suggestions a user receives when typing something into a custom field input.
Note that these custom fields need to be of the type provided by this extension.

	Set($DBCustomField_Fields, {
		'Client' => 'companies'
	});

By default the limit of suggestions displayed to the user is 10. To adjust this you can use the following:

	Set($DBCustomField_Suggestion_Limit, 25);

=head2 ADVANCED CONFIGURATION

=over

=item C<__TICKET__>

Can be used as part of any query to reference a ticket's ID. (Is replaced by this extension with an integer.)

=item C<__VALUE__>

Can be used only as part of the `display_value' query to reference the `field_value'.
(Is replaced by this extension with whatever has been stored internally by RT.)

=back

=head1 AUTHOR

NETWAYS GmbH <support@netways.de>

=head1 BUGS

All bugs should be reported on L<GitHub|https://github.com/NETWAYS/rt-extension-dbcustomfield>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2018 by NETWAYS GmbH

This is free software, licensed under:

    The GNU General Public License, Version 2, June 1991

=cut

1;
