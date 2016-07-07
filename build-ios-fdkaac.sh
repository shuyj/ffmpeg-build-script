ARCHS="armv7 armv7s arm64"
PLATFORM="iPhoneOS"
#PLATFORM="iPhoneSimulator"
XCRUN_SDK=`echo $PLATFORM | tr '[:upper:]' '[:lower:]'`

export GASPREPROCESSPATH=`pwd`/../gas-preprocessor
export PATH=$GASPREPROCESSPATH:$PATH
CC="xcrun -sdk $XCRUN_SDK clang"
#export CC="xcrun -sdk iphoneos clang -Wno-error=unused-command-line-argument-hard-error-in-future"
AS="gas-preprocessor.pl -- $CC"

SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS9.3.sdk"
ALLDIR=
for ARCH in $ARCHS
do
    CFLAGS="-arch $ARCH -mios-version-min=7.0 -fembed-bitcode -isysroot $SYSROOT -Os -Wall -pipe -ffast-math -fstrict-aliasing -Werror=strict-aliasing \
        -mfloat-abi=softfp -mthumb -Wno-sequence-point -Wno-extra"
    LDFLAGS=""
    CXXFLAGS="-arch $ARCH -isysroot $SYSROOT -std=c++98"
    FDKAAC_FLAGS="--host=arm-apple-darwin \
      --enable-static \
      --with-pic=yes    \
      --enable-neon=yes"

    PREFIX=`pwd`/build/ios_$ARCH && mkdir -p $PREFIX
    FDKAAC_FLAGS="$FDKAAC_FLAGS --prefix=$PREFIX"
    if [ "$1" = "build" ]
    then
    ./configure $FDKAAC_FLAGS CC="$CC" CXX="$CC" CPP="$CC -E" CXXCPP="$CC -E" AS="$AS" CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$CFLAGS" CPPFLAGS="$CFLAGS" #| tee $PREFIX/configuration.txt
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
lipo -create $LIBS -output $FATPREFIX/libfdk-aac.a
lipo -info $FATPREFIX/libfdk-aac.a