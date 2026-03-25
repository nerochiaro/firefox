#!/bin/bash

MEDIACAP=~/mediacap

trap 'kill $(jobs -p) 2>/dev/null; wait' EXIT INT TERM

rm -f $MEDIACAP/video.pipe $MEDIACAP/audio.pipe
mkfifo $MEDIACAP/video.pipe
mkfifo $MEDIACAP/audio.pipe

SIZE="1280x720"

ffmpeg \
  -probesize 32 -analyzeduration 0 \
  -f rawvideo -pixel_format yuv420p -video_size ${SIZE} -framerate 24 \
  -i <(mbuffer -i $MEDIACAP/video.pipe -m 2G -T /tmp/mbuffer-video -f) \
  -f f32le -ar 48000 -ac 2 \
  -i <(mbuffer -i $MEDIACAP/audio.pipe -m 500M -T /tmp/mbuffer-audio -f) \
  -c:v libx264 -preset ultrafast -crf 23 \
  -c:a aac \
  -y \
  $MEDIACAP/output.mp4