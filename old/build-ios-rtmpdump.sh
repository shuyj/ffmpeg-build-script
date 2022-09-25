ARCHS="armv7 armv7s arm64"
SDKVERSION="9.3"
PLATFORM="iPhoneOS"
#PLATFORM="iPhoneSimulator"
XCRUN_SDK=`echo $PLATFORM | tr '[:upper:]' '[:lower:]'`

export GASPREPROCESSPATH=`pwd`/../gas-preprocessor
export PATH=$GASPREPROCESSPATH:$PATH
CC="xcrun -sdk $XCRUN_SDK clang"
DEVELOPER=`xcode-select -print-path`
export CROSS_TOP="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
export CROSS_SDK="${PLATFORM}${SDKVERSION}.sdk"
export BUILD_TOOLS="${DEVELOPER}"
#export CC="xcrun -sdk iphoneos clang -Wno-error=unused-command-line-argument-hard-error-in-future"
AS="gas-preprocessor.pl -- $CC"
ALLDIR=
for ARCH in $ARCHS
do
    PREFIX=`pwd`/build/ios_$ARCH && mkdir -p $PREFIX

      echo "Building librtmp for ${PLATFORM} ${SDKVERSION} ${ARCH}"
        echo "Please wait..."
            # add arch to CC=
        sed -ie "s!AR=\$(CROSS_COMPILE)ar!AR=/usr/bin/ar!" "Makefile"
    #    sed -ie "/CC=\$(CROSS_COMPILE)gcc/d" "Makefile"
    #    echo "CC=\$(CROSS_COMPILE)gcc -arch ${ARCH}" >> "Makefile"
      
    export CROSS_COMPILE="${DEVELOPER}/usr/bin/"  
    export XCFLAGS="-arch ${ARCH} -DNO_CRYPTO -Os -isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} -miphoneos-version-min=7.0 -fembed-bitcode"
    export XLDFLAGS="-arch ${ARCH} -isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} -miphoneos-version-min=7.0 -fembed-bitcode"
    if [ "$1" = "build" ]; then
    make SYS=darwin prefix=$PREFIX clean
    make SYS=darwin prefix=$PREFIX all
    make SYS=darwin prefix=$PREFIX install
    fi
    ALLDIR="$ALLDIR $PREFIX"
done
echo "fat lib begin..."
#echo $ALLDIR
FATPREFIX=`pwd`/build/ios_fat && mkdir -p $FATPREFIX
LIBS=`find $ALLDIR -name *.a`
#echo "LIBS:"$LIBS
lipo -create $LIBS -output $FATPREFIX/librtmp.a
lipo -info $FATPREFIX/librtmp.a