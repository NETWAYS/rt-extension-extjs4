#!/bin/bash

RT_DAEMON=${RT_DAEMON:-"enabled"}
RT_PREFIX=${RT_PREFIX:-"/opt/rt4"}
RT_SERVER=${RT_SERVER:-"${RT_PREFIX}/sbin/rt-server"}

echo "----------------------------------------"
echo "  Startup RT:"
echo ""
echo "   - CWD: ${RT_PREFIX}"
echo "   - BIN: ${RT_SERVER}"
echo ""
echo "----------------------------------------"
echo ""

cd $RT_PREFIX

if [ ! "v$RT_DAEMON" == "venabled" ]
then
  while /bin/true; do sleep 1; done
  exit 0
else
  exec $RT_SERVER $@
fi
