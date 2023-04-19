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
TOKEN="cce093c3-26ea-48a0-93c4-1b6c5fb1d23e"
ACCESS_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjUxMywidXNlcl9uYW1lIjoibWxlZmV2cmVAcGFyYWRpZ20uYnJ1c3NlbHMiLCJzY29wZSI6WyJvcGVuaWQiXSwiZXhwIjoxNjgxODk0ODE4LCJpYXQiOjE2ODE4OTM2MTgsImRldmljZUlkIjowLCJhdXRob3JpdGllcyI6WyJST0xFX01FRVRJTkdfVVNFUiIsIlJPTEVfTUFTVEVSREFUQV9VU0VSIiwiUk9MRV9HVUVTVF9VU0VSIiwiUk9MRV9WSVNJTzFfVVNFUiIsIlJPTEVfVVNFUiIsIlJPTEVfTUVNQkVSU0hJUF9VU0VSIl0sImp0aSI6IjhhNmQ1ZGE3LTI5MzctNGJlMS05OTdlLTNlMTE4ZDZjNmIxNiIsInRpZCI6ImNpcmItYnJ1c3NlbHMiLCJjbGllbnRfaWQiOiJ3ZWJfYXBwIn0.GPdsfL3cGBEltVyaSCfnkipKZHUpUyyMpQct7x5kNxRmt5V3nlq0bo0mM9yRZ3romBZTrp7zpebLwaqMPszvhCVBjGPLVYKFifShFVdqgqv1jRRpxVZsV9-jDYWOCeMfV-CQva7rc-hD5nzGnO_0u89B3IDKo1_g19qJFcI-U3IHmDO5wZoa3SNGKkBdR0p-zS2Jgsv_-n_Dj3EH6Bpbm5JEe1Lt6oK7mcDzWpO1Agx-NgydhoTCkigJB8Hjs9mFAG6F0GYn9g3L6hCUJWuNglfVIQr9YbZo5GPuSsNSEVCP-1aZ199EmqnjvhMx60lOCA3mZRCEI4lldocXDuRxaQ"
REFRESH_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjUxMywidXNlcl9uYW1lIjoibWxlZmV2cmVAcGFyYWRpZ20uYnJ1c3NlbHMiLCJzY29wZSI6WyJvcGVuaWQiXSwiYXRpIjoiOGE2ZDVkYTctMjkzNy00YmUxLTk5N2UtM2UxMThkNmM2YjE2IiwiZXhwIjoxNjgyNDk4NDE4LCJpYXQiOjE2ODE4OTM2MTgsImRldmljZUlkIjowLCJhdXRob3JpdGllcyI6WyJST0xFX01FRVRJTkdfVVNFUiIsIlJPTEVfTUFTVEVSREFUQV9VU0VSIiwiUk9MRV9HVUVTVF9VU0VSIiwiUk9MRV9WSVNJTzFfVVNFUiIsIlJPTEVfVVNFUiIsIlJPTEVfTUVNQkVSU0hJUF9VU0VSIl0sImp0aSI6ImY5NzU0YzI1LWEyZjctNDI5Yy04YTYzLTkyYWUxMzhlZTI2NyIsInRpZCI6ImNpcmItYnJ1c3NlbHMiLCJjbGllbnRfaWQiOiJ3ZWJfYXBwIn0.Tx8nerb0pc_Xy41nv9ifO3p7C1buYCYHG48oMjSwrTbloLF_DDttIU0V8wF7cuI1racFCdDLkGdh_seyHIihxRIexy7uS-GtqUf_pYPh7ogTh3RcWvEiEoaB4-4rAZIyNpY9fWB8XRqQV-2mLgVTJHfi6hBMgpeNo_o6g_HZO_ojHfC_RG2C2NZflP0KaYBodHs7MhclPDo15jfDmVcZNyKs7SJlzjiOinJQTUNMl_KXmuqLuAWrJBk6t_lRPLRG4M5R4oD0eWOpgSihzD5gQqApMP_Zw-UPUQWbp_5JpU_PvbI1HJsqnSr6zwtNunlbNL2oK3mOB-F3pTSXxO1xVg"

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

curl 'https://cibg-cirb-brussels.meeting.myc1.eu/gateway/meeting/api/bookings' -X POST -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' -H 'Accept-Encoding: gzip, deflate, br' -H 'X-XSRF-TOKEN: '$TOKEN'' -H 'Content-Type: application/json' -H 'Origin: https://cibg-cirb-brussels.meeting.myc1.eu' -H 'Connection: keep-alive' -H 'Referer: https://cibg-cirb-brussels.meeting.myc1.eu/' -H  'Cookie: refresh_token='$REFRESH_TOKEN'; access_token='$ACCESS_TOKEN'; XSRF-TOKEN='$TOKEN'' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'TE: trailers' --data-raw $POST_CONTENT --compressed


