#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input.mp4> <video_start_ms> <audio_start_ms>"
    exit 1
fi

INPUT=$1
VIDEO_MS=$2
AUDIO_MS=$3
OUTPUT="${INPUT%.*}_synced.mp4"

OFFSET_MS=$((VIDEO_MS - AUDIO_MS))

echo "Video started at ${VIDEO_MS}ms, audio at ${AUDIO_MS}ms, offset=${OFFSET_MS}ms"

if [ $OFFSET_MS -gt 0 ]; then
    OFFSET_SEC=$(echo "scale=3; $OFFSET_MS / 1000" | bc | awk '{printf "%.3f", $1}')
    echo "Delaying audio by ${OFFSET_SEC}s"
    ffmpeg \
        -i $INPUT \
        -itsoffset $OFFSET_SEC \
        -i $INPUT \
        -map 0:v -map 1:a \
        -c:v copy -c:a aac \
        -y $OUTPUT
else
    OFFSET_SEC=$(echo "scale=3; $((-OFFSET_MS)) / 1000" | bc | awk '{printf "%.3f", $1}')
    echo "Delaying video by ${OFFSET_SEC}s"
    ffmpeg \
        -itsoffset $OFFSET_SEC \
        -i $INPUT \
        -i $INPUT \
        -map 0:v -map 1:a \
        -c:v copy -c:a aac \
        -y $OUTPUT
fi

echo "Done: $OUTPUT"