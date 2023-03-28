#!/bin/sh

###################################
# To use to reserve seat at cirb
# 
# Parameters:
#	1. Desired date: (optional) the booking desired date in format yyyy-mm-dd. If not provided, the date 15 days ahead from now is used.
##
# Author : mlefevre@cirb.brussels
###################################


DESIRED_DATE=${1:-$(date -u +'%Y-%m-%d' -d "+ 14 days")}
USER_MAIL="mlefevre@paradigm.brussels"
USER_FISTNAME="Marc"
USER_LASTNAME="LEFEVRE"

CREATION_DATE=$(date -u +'%Y-%m-%dT%T.%3NZ')

# check value and format of provided date:
date -d $DESIRED_DATE > /dev/null 2>&1
if [ "$?" != 0 ];
then
	echo ${1} is not a valid date. Date should be provided in yyyy-mm-dd format.
	exit 1
fi
ORGANIZER='{"email":"'$USER_MAIL'","firstName":"'$USER_FIRSTNAME'","lastName":"'$USER_LASTNAME'","uuaid":513,"mdcompanyId":1,"organizer":true}'
POST_CONTENT='{"creationDate":"'$CREATION_DATE'","communityManagerConfirmationNeeded":false,"communityManagerConfirmed":false,"organizerConfirmationNeeded":false,"organizerConfirmed":false,"finalized":true,"bookingStart":"'$DESIRED_DATE'T06:00:00.000Z","bookingEnd":"'$DESIRED_DATE'T16:00:00.000Z","confirmUrl":"https://cibg-cirb-brussels.meeting.myc1.eu/#/confirmation/","started":false,"cancelled":false,"meetingRoomId":307,"roomLayoutId":313,"organizer":'$ORGANIZER'}'

echo Booking a seat for the $DESIRED_DATE
echo ----- debug infos -----
echo $POST_CONTENT

curl 'https://cibg-cirb-brussels.meeting.myc1.eu/gateway/meeting/api/bookings' -X POST -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' -H 'Accept-Encoding: gzip, deflate, br' -H 'X-XSRF-TOKEN: 3d50fc91-0354-4fda-8c83-f2c6ed308ce5' -H 'Content-Type: application/json' -H 'Origin: https://cibg-cirb-brussels.meeting.myc1.eu' -H 'Connection: keep-alive' -H 'Referer: https://cibg-cirb-brussels.meeting.myc1.eu/' -H 'Cookie: refresh_token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjUxMywidXNlcl9uYW1lIjoibWxlZmV2cmVAcGFyYWRpZ20uYnJ1c3NlbHMiLCJzY29wZSI6WyJvcGVuaWQiXSwiYXRpIjoiMDU1ZjUwMzgtNWQ1OS00YjgzLTlhOGItZjA4ZTQwNmQxZjI5IiwiZXhwIjoxNjgwMTY0ODE2LCJpYXQiOjE2Nzk1NjAwMTYsImRldmljZUlkIjowLCJhdXRob3JpdGllcyI6WyJST0xFX01FRVRJTkdfVVNFUiIsIlJPTEVfTUFTVEVSREFUQV9VU0VSIiwiUk9MRV9HVUVTVF9VU0VSIiwiUk9MRV9WSVNJTzFfVVNFUiIsIlJPTEVfVVNFUiIsIlJPTEVfTUVNQkVSU0hJUF9VU0VSIl0sImp0aSI6IjM0ZjcwZTc3LWY5ZTYtNDdmMy04NzcxLWFhNTg4ZmQ4NmE5MCIsInRpZCI6ImNpcmItYnJ1c3NlbHMiLCJjbGllbnRfaWQiOiJ3ZWJfYXBwIn0.Fo_Bfhtbtrn5B5lNCmzrlNDJda1wZrX_8vLuuVG3lPy0JlONESdh_WO-wup2yAsf0q1HMXzFKfNtr8ew136SkrHJHiLz3d3HvuDpQkmCK5MayWZjviz7TjIWipQwG12Pe6v8QE5juMX53CnKl0_r0ODJXcZYmxfy5SC3XsnYCzVUQsg549ob5I_SeSSOzvAp9e1ABqrx5EQA0BYeBpt4BAC0HQ_bt0fPUdeJqQaX0VfHrfauCrzAGBOHpDG3YpjcjVYxaEdCPMWTmGtS318-1vFIhsKG857egBFXdsA3xJOQ4wa35Q0BHkQ7IZRslfbg7HXUme8FfkJzFsobDVuf7w; access_token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjUxMywidXNlcl9uYW1lIjoibWxlZmV2cmVAcGFyYWRpZ20uYnJ1c3NlbHMiLCJzY29wZSI6WyJvcGVuaWQiXSwiZXhwIjoxNjc5NTYxMjE2LCJpYXQiOjE2Nzk1NjAwMTYsImRldmljZUlkIjowLCJhdXRob3JpdGllcyI6WyJST0xFX01FRVRJTkdfVVNFUiIsIlJPTEVfTUFTVEVSREFUQV9VU0VSIiwiUk9MRV9HVUVTVF9VU0VSIiwiUk9MRV9WSVNJTzFfVVNFUiIsIlJPTEVfVVNFUiIsIlJPTEVfTUVNQkVSU0hJUF9VU0VSIl0sImp0aSI6IjA1NWY1MDM4LTVkNTktNGI4My05YThiLWYwOGU0MDZkMWYyOSIsInRpZCI6ImNpcmItYnJ1c3NlbHMiLCJjbGllbnRfaWQiOiJ3ZWJfYXBwIn0.d-uMJTXWJ5BR43unEmJqNevFeI_UStSZI6_nhK9skaaH6v9FUVfk21LsFBBy6FF4vOn8saWNxEiR9LjvPf_ib3PhIQwbmxTuqiVaF3P6TckViFL_Alj9V8X-X6ymkmwN6PhCO2Gq-V6PSe6FVSFkYrea_aSFmgUBg8Bqj5mm4ix_VX9C7ZCBKpxJ8JRGKtYMn8oYXhy-0M4e_QNd9kpYe8dPm3_SmFXotYSntcvpNzP71CRGZDgDv51LpmHm9ertFpzOT51pFRVJ8lndcqSSksAYsJB1Bo-sOI4Z7k0Ku91aVSUDfYNblq1M0ViMTrKen-mMnhI0MsVfQthoXQ3-9w; XSRF-TOKEN=3d50fc91-0354-4fda-8c83-f2c6ed308ce5' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'TE: trailers' --data-raw $POST_CONTENT


