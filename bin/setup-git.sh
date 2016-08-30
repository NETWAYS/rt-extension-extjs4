#!/bin/bash
BIN_DIR=$(cd $(dirname $0); pwd)
GIT=${GIT:-$(command -v git)}

. $BIN_DIR/functions.sh

cd $BASE_DIR

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
"git://git.netways.org/rt4/rtx-actitime.git"
"git://git.netways.org/rt4/rtx-action-subjectandevent.git"
"git://git.netways.org/rt4/rtx-action-changeowner.git"
"https://gitlab.netways.org/mhein/rtx-customfieldvalues-asset.git")

if [ ! -x $GIT ]; then
    echo "GIT not found"
fi

for G in "${REMOTE[@]}"; do
	REMOTE_NAME=$(basename $G '.git');
	if [[ -z $($GIT config --local "remote.$REMOTE_NAME.url") ]]
	then
		$GIT remote add $REMOTE_NAME $G 2>&1 > /dev/null
		if [[ ! $? ]]
		then
			echo "Could not add remote '$REMOTE_NAME', ignore"
			continue
		fi
	else
		echo "Remote '$REMOTE_NAME' exists"
	fi
	echo -n "Fetch $REMOTE_NAME ... "
	$GIT fetch $REMOTE_NAME 2>&1 > /dev/null
	echo "done"
	PREFIX="$BASE_DIR/vendor/$REMOTE_NAME"
	if [[ ! -d "$PREFIX" ]]
	then
		echo -n "Add subtree to vendor/$REMOTE_NAME ... "
		$GIT subtree add --prefix=$PREFIX --squash $REMOTE_NAME master
		echo "done"
	else
		echo "Subtree exists: $PREFIX"
	fi
	echo ""
done
