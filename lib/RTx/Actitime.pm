package RTx::Actitime;

use strict;
use version;

use RTx::Actitime::Database;

our $VERSION = "0.1.0";

RTx::Actitime::Database->new()->doConnect();

1;