#!/usr/bin/bash

FFMAJ=${STATIC_FFMPEG_MAJOR:-8}

while getopts f:p: opt
do
    case $opt in
        f) pkg_flag=$OPTARG;;
        p) pkg_param=$OPTARG;;
        *) echo "Usage: $0 [-f flag] [-p param]" >&2; exit 1
    esac
done

disabled_params=(
--disable-alsa
--disable-avdevice
--disable-bsfs
--disable-doc
--disable-encoders
--disable-indevs
--disable-muxers
--disable-network
--disable-outdevs
--disable-parsers
--disable-alsa
--disable-programs
--disable-shared
--disable-x86asm
--disable-autodetect
)

#commit 8c920c4c396163e3b9a0b428dd550d3c986236aa
#Author: Michael Niedermayer
#Date:   Mon May 5 19:40:24 2025 +0200
#    Remove libpostproc
[ $FFMAJ -lt 8 ] && disabled_params+=( --disable-postproc )

./configure   \
 --pkg-config-flags="--static $pkg_flag" \
 ${disabled_params[@]} \
 --enable-libzimg \
 --enable-filter=zscale $pkg_param

