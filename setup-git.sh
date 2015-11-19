#!/bin/bash
GIT=$(command -v git)
DIR=$(cd $(dirname $0); pwd)

cd $DIR

REMOTE=(
"git://github.com/bestpractical/rt.git"
"git://git.netways.org/rt4/rtx-dbcustomfield.git"
"git://git.netways.org/rt4/rtx-updatehistory.git"
"git://git.netways.org/rt4/rtx-emailheader.git"
"git://git.netways.org/rt4/rtx-usersearch.git"
"git://git.netways.org/rt4/rtx-historycomponent.git"
"git://git.netways.org/rt4/rtx-searchmarker.git"
"git://git.netways.org/rt4/rtx-action-setowner.git"
"git://git.netways.org/rt4/rtx-create-external.git"
"git://git.netways.org/rt4/rtx-netways.git"
"git://git.netways.org/rt4/rtx-queuecategories.git"
"git://git.netways.org/rt4/rtx-extjs4.git"
"git://git.netways.org/rt4/rtx-ticketactions.git"
"git://git.netways.org/rt4/rtx-addservicedata.git"
"git://git.netways.org/rt4/rtx-createlinkedtickets.git"
"git://git.netways.org/rt4/rtx-actitime.git")

if [ ! -x $GIT ]; then
    echo "GIT not found"
fi

for G in "${REMOTE[@]}"; do
	REMOTE_NAME=$(basename $G '.git');
	$GIT remote add $REMOTE_NAME $G 2>&1 > /dev/null
	RV=$?
	if [ $RV ]; then
		$GIT fetch $REMOTE_NAME
	fi
	if [ ! -d "$DIR/$REMOTE_NAME" ]; then
		$GIT subtree add --prefix=vendor/$REMOTE_NAME --squash $REMOTE_NAME master
	fi
done