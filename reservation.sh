#!/bin/sh

###################################
# To use to reserve seat at cirb
#
# Constants to be set:
#	USER_MAIL, USER_FIRSTNAME, USER_LASTNAME -> self explanatory : use your own.
#	START/END_TIME -> define in UTC time
#	SEAT -> the id (meetingRoomId) of your place (must be defined from the examination of previous request from the UI)
#	LAYOUT -> (roomLayoutId) something related to a place (what exactly ???) (must be defined from previous request in the UI)
#	TOKEN -> id token, must be defined from cookies XSRF-TOKEN retrieved from previous request
# 
# Parameters:
#	1. Desired date: (optional) the booking desired date in format yyyy-mm-dd. If not provided, the date 28 days ahead from now is used.
##
# Author : mlefevre@cirb.brussels
###################################


DESIRED_DATE=${1:-$(date -u +'%Y-%m-%d' -d "+ 28 days")}
USER_MAIL="mlefevre@paradigm.brussels"
USER_FIRSTNAME="Marc"
USER_LASTNAME="LEFEVRE"
START_TIME="06:00"	# in UTC (you must take the daylight shift + difference with GMT into account
END_TIME="16:00"	# hence it's 'actual hour -2' in summer and 'actual hour -1' in winter)
SEAT="307"	# meetingRoomId
LAYOUT="313"	# roomLayoutId ... seems useless, but may be related to seat localisation ??
TOKEN="dee5d8c1-ae09-4c0a-a8ad-2adb393ddfaa"

CREATION_DATE=$(date -u +'%Y-%m-%dT%T.%3NZ')

# check value and format of provided date:
date -d $DESIRED_DATE > /dev/null 2>&1
if [ "$?" != 0 ];
then
	echo ${1} is not a valid date. Date should be provided in yyyy-mm-dd format.
	exit 1
fi
ORGANIZER='{"email":"'$USER_MAIL'","firstName":"'$USER_FIRSTNAME'","lastName":"'$USER_LASTNAME'","uuaid":513,"mdcompanyId":1,"organizer":true}'
POST_CONTENT='{"creationDate":"'$CREATION_DATE'","communityManagerConfirmationNeeded":false,"communityManagerConfirmed":false,"organizerConfirmationNeeded":false,"organizerConfirmed":false,"finalized":true,"bookingStart":"'$DESIRED_DATE'T'$START_TIME':00.000Z","bookingEnd":"'$DESIRED_DATE'T'$END_TIME':00.000Z","confirmUrl":"https://cibg-cirb-brussels.meeting.myc1.eu/#/confirmation/","started":false,"cancelled":false,"meetingRoomId":'$SEAT',"roomLayoutId":'$LAYOUT',"organizer":'$ORGANIZER'}'

JSON=$(curl --silent 'https://cibg-cirb-brussels.meeting.myc1.eu/gatewayauth/login' --compressed -X POST -H 'X-XSRF-TOKEN: '$TOKEN'' -H 'Content-Type: application/json' -H 'Origin: https://cibg-cirb-brussels.meeting.myc1.eu' -H 'Connection: keep-alive' -H 'Referer: https://cibg-cirb-brussels.meeting.myc1.eu/' -H 'Cookie: XSRF-TOKEN='$TOKEN'; access_token='$ACCESS_TOKEN'' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'TE: trailers' --data-raw '{"username":"anonymoususer","password":"user","rememberMe":false}')
ACCESS_TOKEN=$(echo $JSON | jq -r .access_token)
REFRESH_TOKEN=$(echo $JSON | jq -r .refresh_token)

echo Booking a seat for the $DESIRED_DATE

curl 'https://cibg-cirb-brussels.meeting.myc1.eu/gateway/meeting/api/bookings' -X POST -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' -H 'Accept-Encoding: gzip, deflate, br' -H 'X-XSRF-TOKEN: '$TOKEN'' -H 'Content-Type: application/json' -H 'Origin: https://cibg-cirb-brussels.meeting.myc1.eu' -H 'Connection: keep-alive' -H 'Referer: https://cibg-cirb-brussels.meeting.myc1.eu/' -H  'Cookie: refresh_token='$REFRESH_TOKEN'; access_token='$ACCESS_TOKEN'; XSRF-TOKEN='$TOKEN'' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'TE: trailers' --data-raw $POST_CONTENT --compressed

