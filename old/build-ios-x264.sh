ARCHS="armv7 armv7s arm64"
PLATFORM="iPhoneOS"
#PLATFORM="iPhoneSimulator"
XCRUN_SDK=`echo $PLATFORM | tr '[:upper:]' '[:lower:]'`

export GASPREPROCESSPATH=`pwd`/../gas-preprocessor
export PATH=$GASPREPROCESSPATH:$PATH
export CC="xcrun -sdk $XCRUN_SDK clang"
export AS="gas-preprocessor.pl -- $CC"
ALLDIR=
for ARCH in $ARCHS
do
  if [ $ARCH = "arm64" ]; then
      X264_FLAGS="--host=aarch64-apple-darwin"
  else
      X264_FLAGS="--host=arm-apple-darwin"
  fi
    X264_FLAGS+=" --enable-pic	\
    --enable-static"

  SYSROOT=
  PREFIX=`pwd`/build/ios_$ARCH && mkdir -p $PREFIX
  X264_FLAGS="$X264_FLAGS --prefix=$PREFIX"
  # -Ofast
  EXTRA_CFLAGS="-arch $ARCH -mios-version-min=7.0 -fembed-bitcode -Os -Wall -pipe -std=c99 -ffast-math -fstrict-aliasing  \
  	-march=$ARCH -mfloat-abi=softfp -mthumb"
  #-ffunction-sections -mfpu=neon -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__

  EXTRA_LDFLAGS=
  EXTRA_ASFLAGS="-arch $ARCH -mios-version-min=7.0 -fembed-bitcode -Wall -pipe"

  CXXFLAGS="$EXTRA_CFLAGS"
  LDFLAGS="$EXTRA_CFLAGS"
  export LDFLAGSCLI="$EXTRA_CFLAGS"
  if [ "$1" = "build" ];then
  ./configure $X264_FLAGS --sysroot=$SYSROOT --extra-cflags="$EXTRA_CFLAGS" --extra-asflags="$EXTRA_ASFLAGS" --extra-ldflags="$EXTRA_LDFLAGS" #| tee $PREFIX/configuration.txt
    cp config.* $PREFIX
    [ $PIPESTATUS == 0 ] || exit 1

    make clean
    make -j4 || exit 1
    make install || exit 1
  fi
  ALLDIR="$ALLDIR $PREFIX"
done
echo "fat lib begin..."
#echo $ALLDIR
FATPREFIX=`pwd`/build/ios_fat && mkdir -p $FATPREFIX
LIBS=`find $ALLDIR -name *.a`
#echo "LIBS:"$LIBS
lipo -create $LIBS -output $FATPREFIX/libx264.a
lipo -info $FATPREFIX/libx264.a