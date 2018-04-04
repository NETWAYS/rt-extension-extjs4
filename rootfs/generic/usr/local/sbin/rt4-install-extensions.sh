#!/bin/bash

RT_SOURCE=${RT_SOURCE:-/opt/rt4}
RT_PLUGIN_LIST=${RT_PLUGIN_LIST:-""}
PERL=${PERL:-$(command -v perl)}
MAKE=${MAKE:-$(command -v make)}
CDIR=$(pwd)
INIT_MAKE_FILE=Makefile.PL

if [[ ! -x "$PERL" ]]
then
	echo "Perl interpreter not found (PERL)"
	exit 1
fi

if [[ ! -d "$RT_SOURCE" ]]
then
	echo "RT source directory does not exist (RT_SOURCE)"
	exit 1
fi

if [[ -z "$RT_PLUGIN_LIST" ]]
then
	if (( $# > 0 ))
	then
		RT_PLUGIN_LIST="$@"
	else
		echo "No plugins configured (RT_PLUGIN_LIST)"
		exit 1
	fi
fi

cd $RT_SOURCE

for I in $RT_PLUGIN_LIST
do
	PLUGIN_PATH=$RT_SOURCE/$I
	echo "* Install $I ($PLUGIN_PATH)"
	if [[ ! -d $PLUGIN_PATH ]]
	then
		echo "* Path not found for plugin '$I'"
		exit 1
	else
		echo "* Creating Makefile ($PERL $INIT_MAKE_FILE)"
	fi
	cd $PLUGIN_PATH
	$PERL $INIT_MAKE_FILE
	$MAKE
	$MAKE install
	echo ""
done

cd $CDIR
