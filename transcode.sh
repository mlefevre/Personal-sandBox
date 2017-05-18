#!/bin/sh

# Script to transcode video file with a coding used by classical televisor : xvid

# @Param : [1] the directory where the movie are. 
#	   [..] the movie to treat
# @Return : 1 if error, 0 otherwise
# @Output : log in log files contained in the DIRECTORY
#           Utf-8 subtitle file 
#           reencoded movie with same name and extension .stfr.avi

#PATH="$1"
LOG="$0".log
DESTINATION=$HOME/Documents/Tests/Encoded/

#cd "$PATH"
#echo parameter = $PATH > $LOG
echo $#
#for movie in $*; do
movie=$1
  echo convert $movie in xvid
  mencoder "$movie" -ovc xvid -xvidencopts bitrate=900 -oac mp3lame -o $DESTINATION$movie
#done
exit 0




#for MOVIE in *.avi; do
#  BASE_NAME=${MOVIE%avi}
#  SUBTITLE="$BASE_NAME"srt
#  echo convert SUBTITLE into utf8
#  iconv --verbose -f iso-8859-15 -t utf8 -o "$SUBTITLE.converted" "$SUBTITLE" >>$LOG
#  if [ $? -ne 0 ]; 
#    then
#    echo error when encoding $SUBTITLE
#    exit 1
#  fi

#  echo ========== include SUBTITLE in $MOVIE ==========
#  mencoder "$MOVIE" -ovc xvid -xvidencopts bitrate=900 -oac mp3lame -sub "$SUBTITLE.converted" -subcp utf8 -o "$BASE_NAME"stfr.avi  
#  if [ $? -ne 0 ];
#    then
#    echo error when re-encoding $MOVIE with $SUBTITLE
#    exit 1
#  fi
#done

