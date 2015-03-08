#!/bin/bash

USERNAME="" #INWX USERNAME
PASSWORD="" #INWX PASSWORD
DNSID="" #DNS Entry ID
APIHOST="https://api.domrobot.com/xmlrpc/"
OLDIP=$(cat old.ip)
NEWIP=$(curl -s curlmyip.com)

#If we did not get an IP because the service is down we try another one
if [ -z "$NEWIP" ]; then
  NEWIP=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')
fi

if [ ! "$OLDIP" == "$NEWIP" -a -n "$NEWIP" ]; then
    echo $NEWIP > old.ip
    DATA=$(cat update.api | sed "s/%PASSWD%/$PASSWORD/g;s/%USER%/$USERNAME/g;s/%DNSID%/$DNSID/g;s/%NEWIP%/$NEWIP/g")
    curl  -X POST -d "$DATA" "$APIHOST" --header "Content-Type:text/xml" --insecure > update.log
else
    echo "Error: Could not get ip" > update.log
fi

