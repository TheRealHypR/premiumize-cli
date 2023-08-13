#!/bin/bash

api_key="[APIKEY]"

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
	JSON=$(curl -X 'POST' 'https://www.premiumize.me/api/transfer/directdl?apikey='"$api_key" -H 'accept: application/json' -H 'Content-Type: application/x-www-form-urlencoded' -d 'src='"$1")

	STATUS=$(echo $JSON | jq -r .status)
	#MESSAGE=$(echo $JSON | jq -r .statusmessage)
        #no statusmessage provided by api anymore!

	if [ $STATUS == 200 ] 
	then
		LOCATION=$(echo $JSON | jq -r .location)
		NAME=$(echo $JSON | jq -r .filename)

		echo $NAME
		curl --progress-bar -o $NAME $LOCATION
	else
		echo "somthing went wrong." #$MESSAGE
	fi
done
