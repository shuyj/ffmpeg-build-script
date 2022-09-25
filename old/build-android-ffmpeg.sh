#!/bin/sh
export PATH=$ANDROID_NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin:$PATH
export CC=arm-linux-androideabi-gcc
export LD=arm-linux-androideabi-ld
export AR=arm-linux-androideabi-ar

# armv5 flags:-march=armv5te -mtune=arm9tdmi -msoft-float 
# armv7 flags:-march=armv7-a -mcpu=cortex-a8 -mfpu=vfpv3-d16 -mfloat-abi=softfp -mthumb  ffmpeg:--cpu=cortex-a8 --enable-neon --enable-thumb
# arm64 --arch=aarch64 --enable-yasm ffmpeg:--cross-prefix=aarch64-linux-android-

FFMPEG_FLAGS="--target-os=linux \
	--cross-prefix=arm-linux-androideabi- \
	--enable-cross-compile \
	--enable-pic --enable-asm --enable-inline-asm \
	--arch=arm \
	--cpu=cortex-a8 \
	--enable-neon \
	--enable-thumb \
	--enable-optimizations  --enable-small  \
	--enable-gpl \
	--enable-nonfree \
	--enable-runtime-cpudetect \
	--disable-gray \
	--disable-swscale-alpha \
	--disable-programs \
	--disable-ffmpeg \
	--disable-ffplay \
	--disable-ffprobe \
	--disable-ffserver \
	--disable-doc \
	--disable-htmlpages \
	--disable-manpages \
	--disable-podpages \
	--disable-txtpages \
	--disable-avdevice \
	--enable-avcodec \
	--enable-avformat \
	--enable-avutil \
	--disable-postproc \
	--disable-avfilter \
	--disable-avresample \
	--enable-network \
	--disable-d3d11va \
	--disable-dxva2 \
	--disable-vaapi \
	--disable-vda \
	--disable-vdpau \
	--disable-videotoolbox \
	--disable-encoders \
	--disable-decoders \
	--disable-swresample \
	--disable-swscale \
	--enable-libfdk-aac	\
	--enable-encoder=libfdk_aac
	--enable-encoder=libx264 \
	--enable-libx264	\
	--disable-hwaccels \
	--disable-muxers \
	--enable-muxer=flv \
	--disable-demuxers \
	--disable-parsers \
	--enable-parser=aac \
	--enable-parser=aac_latm \
	--enable-parser=h264 \
	--disable-bsfs \
	--enable-bsf=aac_adtstoasc \
	--enable-bsf=h264_mp4toannexb \
	--disable-protocols \
	--enable-protocol=librtmp \
	--enable-librtmp	\
	--enable-protocol=rtmp \
	--disable-devices \
	--disable-filters \
	--disable-iconv"



PREFIX=`pwd`/build/android_ffmpeg && mkdir -p $PREFIX
SYSROOT=$ANDROID_NDK/platforms/android-9/arch-arm
FFMPEG_FLAGS="$FFMPEG_FLAGS --prefix=$PREFIX"

CFLAGS="-fpic -fasm -finline-limit=300 -fmodulo-sched -fmodulo-sched-allow-regmoves"

EXTRA_CFLAGS="-O3 -Wall -pipe -std=c99 -ffast-math -fstrict-aliasing -Werror=strict-aliasing -Wno-psabi -Wa,--noexecstack \
	-DANDROID -DNDEBUG -march=armv7-a -mcpu=cortex-a8 -mfpu=vfpv3-d16 -mfloat-abi=softfp -mthumb"
EXTRA_LDFLAGS="-Wl,--fix-cortex-a8"

if [ "$1" = "config" ]; then
	echo $FFMPEG_FLAGS
	./configure $FFMPEG_FLAGS --sysroot=$SYSROOT --extra-cflags="$EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS" --pkg-config=./fake-pkg-config #| tee $PREFIX/configuration.txt
	cp config.* $PREFIX
	[ $PIPESTATUS == 0 ] || exit 1
fi
#  make clean
  make -j4 || exit 1
  make install || exit 1
#libavutil/*.o libavutil/arm/*.o \
#libavcodec/*.o libavcodec/arm/*.o libavformat/*.o libswresample/*.o libswresample/arm/*.o libswscale/*.o libswscale/arm/*.o \
#libavfilter/*.o compat/strtod.o
#libavcodec/libavcodec.a \
#	libavfilter/libavfilter.a libavformat/libavformat.a libavutil/libavutil.a libswresample/libswresample.a libswscale/libswscale.a \
pkg_config=./fake-pkg-config
x264_pkg_libs=$($pkg_config --libs x264)
librtmp_pkg_libs=$($pkg_config --libs librtmp)
libfdkaac_pkg_libs=$($pkg_config --libs fdk-aac)
  $CC -lm -lz -shared --sysroot=$SYSROOT -Wl,--no-undefined -Wl,-z,noexecstack $EXTRA_LDFLAGS -Wl,--whole-archive $PREFIX/lib/*.a \
	-Wl,--no-whole-archive $x264_pkg_libs $librtmp_pkg_libs $libfdkaac_pkg_libs -o $PREFIX/libffmpeg.so

  cp $PREFIX/libffmpeg.so $PREFIX/libffmpeg-debug.so
  arm-linux-androideabi-strip --strip-unneeded $PREFIX/libffmpeg.so
