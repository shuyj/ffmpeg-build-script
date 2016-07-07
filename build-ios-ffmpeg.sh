#!/bin/sh
ARCHS="armv7 armv7s arm64"
export GASPREPROCESSPATH=`pwd`/../gas-preprocessor
export PATH=$GASPREPROCESSPATH:$PATH
PLATFORM="iPhoneOS"
#PLATFORM="iPhoneSimulator"
XCRUN_SDK=`echo $PLATFORM | tr '[:upper:]' '[:lower:]'`
export CC="xcrun -sdk $XCRUN_SDK clang"
export AS="gas-preprocessor.pl -- $CC"
# arm64 x86_64 i386  --host=arm-apple-darwin aarch64
#	--cpu=cortex-a8 \
# 	--enable-protocol=rtmp \
#   --enable-optimizations  --enable-debug  --enable-small
# armv7s may be add  --cpu=swift   arm64 需要 make -j3 GASPP_FIX_XCODE5=1 
# armv7 arm64 diff arch=xx mios-version=xx
# android  ios    -mios-version-min=6.0 -fembed-bitcode
FFMPEG_FLAGS="--target-os=darwin \
	--enable-cross-compile \
	--enable-pic --enable-asm --enable-inline-asm --enable-neon \
	--enable-thumb \
    --enable-optimizations  --enable-small --disable-debug \
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
	--disable-devices \
	--disable-filters \
	--disable-iconv"
ALLDIR=
for ARCH in $ARCHS
do
	PREFIX=`pwd`/build/ios_$ARCH && mkdir -p $PREFIX
	SYSROOT=
	FFMPEG_FLAGS_CUR="--prefix=$PREFIX $FFMPEG_FLAGS --arch=$ARCH"

	CFLAGS="-fpic -fasm -finline-limit=300 -fmodulo-sched -fmodulo-sched-allow-regmoves"
	# -Os  -Oz  
	EXTRA_CFLAGS="-arch $ARCH -mfloat-abi=softfp -Os -Wall -pipe -std=c99 -ffast-math -fstrict-aliasing -Werror=strict-aliasing \
		 -mthumb -mios-version-min=7.0 -fembed-bitcode" # -arch arm64 armv7 x86_64 i386  -mcpu=cortex-a8 -mfpu=vfpv3-d16
	EXTRA_LDFLAGS="$EXTRA_CFLAGS"

	if [ "$1" = "build" ]; then
		echo $FFMPEG_FLAGS_CUR
		export FARCH="$ARCH"
		./configure $FFMPEG_FLAGS_CUR --sysroot=$SYSROOT --extra-cflags="$EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS" --pkg-config=./fake-pkg-config --cc="$CC" #| tee $PREFIX/configuration.txt
		[ $PIPESTATUS == 0 ] || exit 1
		cp config.* $PREFIX
		make clean
#		if [ "$ARCH" = "arm64" ]
#		then
#		    EXPORT="GASPP_FIX_XCODE5=1"
#		fi
		make -j4 $EXPORT || exit 1
		make install $EXPORT || exit 1
	fi
	ALLDIR="$ALLDIR $PREFIX"
done
ALLLIBS="libavcodec.a libavformat.a libavutil.a"
echo "fat lib begin..."
echo "ALLDIR"$ALLDIR
FATPREFIX=`pwd`/build/ios_fat && mkdir -p $FATPREFIX
for LIB in $ALLLIBS
do
	LIBS=`find $ALLDIR -name $LIB`
	echo "LIBS:"$LIBS
	lipo -create $LIBS -output $FATPREFIX/$LIB
	lipo -info $FATPREFIX/$LIB
done
#libavutil/*.o libavutil/arm/*.o \
#libavcodec/*.o libavcodec/arm/*.o libavformat/*.o libswresample/*.o libswresample/arm/*.o libswscale/*.o libswscale/arm/*.o \
#libavfilter/*.o compat/strtod.o
#libavcodec/libavcodec.a \
#	libavfilter/libavfilter.a libavformat/libavformat.a libavutil/libavutil.a libswresample/libswresample.a libswscale/libswscale.a \

#pkg_config=./fake-pkg-config
#x264_pkg_libs=$($pkg_config --libs x264)
#librtmp_pkg_libs=$($pkg_config --libs librtmp)
#libfdkaac_pkg_libs=$($pkg_config --libs fdk-aac)
#  $CC -v -lm -lz -shared --sysroot=$SYSROOT $EXTRA_LDFLAGS -all_load $PREFIX/lib/*.a \
#	$x264_pkg_libs $librtmp_pkg_libs $libfdkaac_pkg_libs -o $PREFIX/libffmpeg.dylib

#for LIB in *.a
#    do
#        cd $CWD
#        echo lipo -create `find $THIN -name $LIB` -output $FAT/lib/$LIB 1>&2
#        lipo -create `find $THIN -name $LIB` -output $FAT/lib/$LIB || exit 1
#    done

#cp $PREFIX/libffmpeg.dylib $PREFIX/libffmpeg-debug.dylib
#strip -x $PREFIX/libffmpeg.dylib
