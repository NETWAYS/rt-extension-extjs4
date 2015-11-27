#!/bin/bash
POSTMAP=${POSTMAP:-$(command -v postmap)}
NEWALIASES=${NEWALIASES:-$(command -v newaliases)}
POSTFIX=${POSTFIX:-$(command -v postfix)}

declare -a TABLES=(
/etc/postfix/mynetworks
/etc/postfix/mydomains
/etc/postfix/virtual
/etc/postfix/canonical
/etc/postfix/transport
)

for T in ${TABLES[@]}; do
	echo -n "Maps tables $T ... "
	if [[ -f $T ]]; then
		$POSTMAP $T
		echo "done"
	else
		echo "NOTEXIST"
	fi
done

echo -n "Exec newaliases ... "
$NEWALIASES
echo "done"

echo -n "Postfix reload ... "
$POSTFIX reload 2> /dev/null

exit 0
