#!/bin/bash

id="[USERID]"
pass="[USERPASS]"


case "$1" in
	*.dlc)
		links=$(curl -s 'http://dcrypt.it/decrypt/paste' --data-urlencode "content@$1" |jq -r .success.links|grep -Po ' "\K[^"]*')
		;;
	*.links)
		links=$(cat $1)
		;;
	*.txt)
		links=$(cat $1)
		;;
	*)
		echo $"Usage: $0 { dlc-File | list-File }"
		echo "A File containing a list of URLs"
		exit 1
esac
for i in $links;
do
	JSON=$(curl -s "https://api.premiumize.me/pm-api/v1.php?method=directdownloadlink&params\[login\]=$id&params\[pass\]=$pass&params\[link\]=$i")

	STATUS=$(echo $JSON | jq -r .status)
	MESSAGE=$(echo $JSON | jq -r .statusmessage)

	if [ $STATUS == 200 ] 
	then
		LOCATION=$(echo $JSON | jq -r .result.location)
		NAME=$(echo $JSON | jq -r .result.filename)

		echo $NAME
		curl --progress-bar -o $NAME $LOCATION
	else
		echo "Error:" $MESSAGE
	fi
done