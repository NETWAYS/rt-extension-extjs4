#!/bin/bash
BIN_DIR=$(cd $(dirname $0); pwd)
GIT=${GIT:-$(command -v git)}

. $BIN_DIR/functions.sh

cd $BASE_DIR

REMOTE=(
"https://github.com/bestpractical/rt.git"
"https://git.netways.org/rt4/rtx-dbcustomfield.git"
"https://git.netways.org/rt4/rtx-updatehistory.git"
"https://git.netways.org/rt4/rtx-emailheader.git"
"https://git.netways.org/rt4/rtx-usersearch.git"
"https://git.netways.org/rt4/rtx-historycomponent.git"
"https://git.netways.org/rt4/rtx-action-setowner.git"
"https://git.netways.org/rt4/rtx-create-external.git"
"https://git.netways.org/rt4/rtx-netways.git"
"https://git.netways.org/rt4/rtx-queuecategories.git"
"https://git.netways.org/rt4/rtx-extjs4.git"
"https://git.netways.org/rt4/rtx-ticketactions.git"
"https://git.netways.org/rt4/rtx-addservicedata.git"
"https://git.netways.org/rt4/rtx-createlinkedtickets.git"
"https://git.netways.org/rt4/rtx-actitime.git"
"https://git.netways.org/rt4/rtx-action-subjectandevent.git"
"https://git.netways.org/rt4/rtx-action-changeowner.git"
"https://git.netways.org/rt4/rtx-customfieldvalues-asset.git")

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
