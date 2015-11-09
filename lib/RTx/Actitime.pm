package RTx::Actitime;

use strict;
use version;

use RT::System;
use RTx::Actitime::Database;

our $VERSION = "0.1.0";

RT::System->AddRight('Staff' => 'ShowActitimeIntegration' => 'Show the actitime box in Ticket Summary');

RTx::Actitime::Database->new()->doConnect();

1;