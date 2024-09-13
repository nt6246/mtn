#!/usr/bin/bash

while getopts f:p: opt
do
    case $opt in
        f) pkg_flag=$OPTARG;;
        p) pkg_param=$OPTARG;;
        *) echo "Usage: $0 [-f flag] [-p param]" >&2; exit 1
    esac
done

./configure   \
--pkg-config-flags="--static $pkg_flag" \
--disable-alsa \
--disable-avdevice \
--disable-bsfs \
--disable-doc \
--disable-encoders \
--disable-indevs \
--disable-muxers \
--disable-network \
--disable-outdevs \
--disable-parsers \
--disable-postproc \
--disable-programs \
--disable-shared \
--disable-x86asm \
--disable-autodetect \
--enable-libzimg \
--enable-filter=zscale $pkg_param

