#!/usr/bin/perl

use strict;
use warnings;

system('sh', 'configure', @ARGV) == 0
    || die("Configure failed: $!");

exit(0);
