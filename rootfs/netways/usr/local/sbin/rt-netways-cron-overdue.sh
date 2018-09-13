#!/bin/bash

CRON=/opt/rt4/bin/rt-crontool

if [[ ! -x $CRON ]]; then
        echo "Crontool is not executable"
        exit 1
fi

$CRON \
        --search RT::Search::FromSQL \
        --search-arg "id>0 and Status='__Active__' and (Queue != 'NETWAYS Billing')" \
        --condition RT::Condition::Overdue \
        --action RT::Action::RecordComment \
        --transaction last \
        --template 93
