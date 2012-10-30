package RTx::Actitime;

use strict;
use version;

use RT::System;
use RTx::Actitime::Database;

our $VERSION = "0.1.0";

our $RIGHTS = {
    ShowActitimeIntegration => "Show the actitime box in Ticket Summary"
};

our $RIGHTS_CATEGORIES = {
    ShowActitimeIntegration => "Staff"
};

RT::System->AddRights(%{ $RIGHTS });
RT::System->AddRightCategories(%{ $RIGHTS_CATEGORIES });

RTx::Actitime::Database->new()->doConnect();

1;