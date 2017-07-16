#!/bin/bash

# Encode subtitle in utf8.
# param $1 = movie base name
# param $2 = subtitle file extension

function convertSubtitle {
  BASE_NAME=$1
  SUBTITLE_EXT=$2

  SUBTITLE="$BASE_NAME"$SUBTITLE_EXT
  echo convert SUBTITLE into utf8
  iconv --verbose -f iso-8859-15 -t utf8 -o "$SUBTITLE.converted" "$SUBTITLE" >>$LOG
  if [ $? -ne 0 ]; 
    then
    echo error when encoding $SUBTITLE
    exit 1
  fi
}

# Encode in xvid (bitrate=900) and mp3.
# param $1 = movie base name (without the extension)
# param $2 = movie extension (after the point)
# param $3 = subtitle file extension

function encodeWithSubtitle {
  BASE_NAME=$1
  MOVIE_EXT=$2
  SUBTITLE_EXT=$3

  MOVIE="$BASE_NAME"$MOVIE_EXT
  SUBTITLE="$BASE_NAME"$SUBTITLE_EXT

  echo ========== include SUBTITLE in $MOVIE ==========
  mencoder "$MOVIE" -ovc xvid -xvidencopts bitrate=900 -oac mp3lame -sub "$SUBTITLE.converted" -subcp utf8 -o "$BASE_NAME"stfr.$MOVIE_EXT
  #mencoder "$MOVIE" -oac mp3lame -lameopts abr:br=128 -ovc x264 -x264encopts pass=1:subq=1:frameref=2:threads=auto -sub "$SUBTITLE.converted" -subcp utf8 -o /dev/null # OK
  #mencoder "$MOVIE" -oac mp3lame -lameopts abr:br=128 -ovc x264 -x264encopts pass=2:subq=5:frameref=6:threads=auto:bitrate=900 -sub "$SUBTITLE.converted" -subcp utf8 -o "$BASE_NAME"stfr.$MOVIE_EXT # OK
  if [ $? -ne 0 ];
    then
    echo error when re-encoding $MOVIE with $SUBTITLE
    exit 1
  fi
}


# Script used to include subtitle in video. The movie and its related subtitle file must have
# the same name, except for the extension which must be .avi and .srt
# @Param : [1] the directory where the movie and the subtitle are. All the movie in the directory will be converted
# @Return : 1 if error, 0 otherwise
# @Output : log in log files contained in the DIRECTORY
#           Utf-8 subtitle file 
#           reencoded movie with same name and extension .stfr.avi
DIRECTORY="$1"
LOG="$0".log

cd "$DIRECTORY"
echo parameter = $DIRECTORY > $LOG
for MOVIE in *.mp4; do
  echo $MOVIE >> $LOG
  if [ -f "$MOVIE" ]; 
    then
    BASE_NAME=${MOVIE%mp4}
    convertSubtitle "$BASE_NAME" srt
    encodeWithSubtitle "$BASE_NAME" mp4 srt
  fi
done
for MOVIE in *.avi; do
  echo $MOVIE >> $LOG
  if [ -f "$MOVIE" ];
    then
    BASE_NAME=${MOVIE%avi}
    convertSubtitle "$BASE_NAME" srt
    encodeWithSubtitle "$BASE_NAME" avi srt
  fi  
done
exit
