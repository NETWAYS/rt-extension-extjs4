#!/bin/bash
set -e

NAME=$(basename $0 '.sh')
CRONTOOL="/opt/rt4/bin/rt-crontool"
DAYS="5"

$CRONTOOL \
  --search RT::Search::FromSQL \
  --search-arg "Queue = 'Automail' \
    AND (Status != 'resolved' AND Status != 'rejected') \
    AND LastUpdated <= '$DAYS days ago'" \
  --action RT::Action::SetStatus \
  --action-arg resolved \
  --verbose
