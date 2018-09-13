#!/bin/bash

CRON=/opt/rt4/bin/rt-crontool

if [[ ! -x $CRON ]]; then
        echo "Crontool is not executable"
        exit 1
fi

$CRON \
  --verbose \
  --search RT::Search::FromSQL \
  --search-arg "Owner = 'Nobody' AND Status = '__Active__' AND LastUpdated < '2 hours ago'" \
  --condition RT::Condition::AnyTransaction \
  --action RT::Action::RecordComment \
  --transaction last \
  --template 157
