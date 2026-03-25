#!/bin/sh

rm /tmp/capture_start

LIBVA_DRIVER_NAME=disable \
MOZ_DISABLE_GPU_SANDBOX=1 \
MOZ_DISABLE_CONTENT_SANDBOX=1 \
MOZ_DISABLE_GMP_SANDBOX=1 \
MOZ_DISABLE_RDD_SANDBOX=1 \
MOZ_LOG="FFmpegLib:3,PlatformDecoderModule:3" \
source/obj-*/dist/bin/firefox \
https://netflix.com 2>&1
