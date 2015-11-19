

use strict;
use warnings;

use RT::Test tests => 12;
use_ok('RT');


my $q = RT::Queue->new(RT->SystemUser);
my $queue = 'SearchTests-'.$$;
$q->Create(Name => $queue);
ok ($q->id, "Created the queue");

my $t1 = RT::Ticket->new(RT->SystemUser);
my ( $id, undef, $msg ) = $t1->Create(
    Queue      => $q->id,
    Subject    => 'SearchTest1',
    Requestor => ['search2@example.com'],
);
ok( $id, $msg );

use_ok("RT::Search::Simple");

my $active_statuses = join( " OR ", map "Status = '$_'", RT::Queue->ActiveStatusArray());

my $tickets = RT::Tickets->new(RT->SystemUser);
my $quick = RT::Search::Simple->new(Argument => "",
                                 TicketsObj => $tickets);
my @tests = (
    "General new open root"     => "( Owner = 'root' ) AND ( Queue = 'General' ) AND ( Status = 'new' OR Status = 'open' )", 
    "General"              => "( Queue = 'General' ) AND ( $active_statuses )",
    "General any"          => "( Queue = 'General' )",
    "fulltext:jesse"       => "( Content LIKE 'jesse' ) AND ( $active_statuses )",
    $queue                 => "( Queue = '$queue' ) AND ( $active_statuses )",
    "root $queue"          => "( Owner = 'root' ) AND ( Queue = '$queue' ) AND ( $active_statuses )",
    "notauser $queue"      => "( Subject LIKE 'notauser' ) AND ( Queue = '$queue' ) AND ( $active_statuses )",
    "notauser $queue root" => "( Subject LIKE 'notauser' ) AND ( Owner = 'root' ) AND ( Queue = '$queue' ) AND ( $active_statuses )");

while (my ($from, $to) = splice @tests, 0, 2) {
    is($quick->QueryToSQL($from), $to, "<$from> -> <$to>");
}
