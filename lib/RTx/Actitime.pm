package RTx::Actitime;

use strict;
use version;

use RT::System;
use RTx::Actitime::Database;

our $VERSION = "0.1.0";

RT::System->AddRight('Staff' => 'ShowActitimeIntegration' => 'Show the actitime box in Ticket Summary');

my $connection = RTx::Actitime::Database->new();
if ($connection->usePool eq '1') {
	RT->Logger->info('Actitime: Database pool enabled, connect to database');
	$connection->doConnect();
} else {
	RT->Logger->info('Actitime: Database pool disabled, do not connect');
}

1;