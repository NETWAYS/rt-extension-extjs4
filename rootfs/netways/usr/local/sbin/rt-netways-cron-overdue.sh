#!/bin/bash

CRON=/storage/www/rt42.netways.de/bin/rt-crontool

if [[ ! -x $CRON ]]; then
        echo "Crontool is not executable"
        exit 1
fi


$CRON \
        --search RT::Search::FromSQL \
        --search-arg "id>0 and (Status='new' or Status='open' or Status='stalled') and (Queue != 'NETWAYS Billing')" \
        --condition RT::Condition::Overdue \
        --action RT::Action::RecordComment \
        --transaction last \
        --template "DEFAULT Overdue"