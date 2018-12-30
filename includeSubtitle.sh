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
  OUTPUT_FOLDER="$4"

  MOVIE="$BASE_NAME"$MOVIE_EXT
  SUBTITLE="$BASE_NAME"$SUBTITLE_EXT
  if [ -z "$4"  ];	# if there is no $4
	then
	OUTPUT_FOLDER=".";
  fi

  echo ========== include SUBTITLE in $MOVIE ==========
  exec mencoder "$MOVIE" \
	  -ovc xvid -xvidencopts bitrate=900 \
	  -oac mp3lame \
	  -sub "$SUBTITLE.converted" -subcp utf8 \
	  -o "$OUTPUT_FOLDER/$BASE_NAME"stfr.$MOVIE_EXT \
	  2>/dev/null
#  exec  mencoder "$MOVIE" \
#	  -ovc lavc -oac lavc -of mpeg\
#	  -lavcopts vcodec=mpeg2video:keyint=1:vbitrate=900:vrc_maxrate=9000:vrc_buf_size=1835 \
#	  -vf harddup -mpegopts muxrate=13000 \
#	  -sub "$SUBTITLE.converted" -subcp utf8 \
#	  -o "$BASE_NAME"stfr.$MOVIE_EXT 2>/dev/null
  if [ $? -ne 0 ];
    then
    echo error when re-encoding $MOVIE with $SUBTITLE
    exit 1
  fi
}


# Script used to include subtitle in video. The movie and its related subtitle file must have
# the same name, except for the extension which must be .avi and .srt
# @Param : 
#       [1] the directory where the movie and the subtitle are. All the movie in the directory will be converted
#       [2] the output directory (optional)
# @Return : 1 if error, 0 otherwise
# @Output : log in log files contained in the DIRECTORY
#           Utf-8 subtitle file 
#           reencoded movie with same name and extension .stfr.avi
DIRECTORY="$1"
LOG="$0".log
OUTPUT_FOLDER="$2"

cd "$DIRECTORY"
echo parameter = $DIRECTORY > $LOG
for MOVIE in *.mp4; do
  echo $MOVIE >> $LOG
  if [ -f "$MOVIE" ]; 
    then
    BASE_NAME=${MOVIE%mp4}
    convertSubtitle "$BASE_NAME" srt
    encodeWithSubtitle "$BASE_NAME" mp4 srt "$OUTPUT_FOLDER"
  fi
done
for MOVIE in *.avi; do
  echo $MOVIE >> $LOG
  if [ -f "$MOVIE" ];
    then
    BASE_NAME=${MOVIE%avi}
    convertSubtitle "$BASE_NAME" srt
    encodeWithSubtitle "$BASE_NAME" avi srt "$OUTPUT_FOLDER"
  fi  
done
for MOVIE in *.mkv; do
  echo $MOVIE >> $LOG
  if [ -f "$MOVIE" ];
    then
    BASE_NAME=${MOVIE%mkv}
    convertSubtitle "$BASE_NAME" srt
    encodeWithSubtitle "$BASE_NAME" mkv srt "$OUTPUT_FOLDER"
  fi  
done
exit
