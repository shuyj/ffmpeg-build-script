#   git clone https://github.com/openssl/openssl.git
#	cd openssl 
#	git checkout OpenSSL_1_1_0i   # OpenSSL_1_1_1m

SDK_HOME=`xcrun --sdk iphoneos --show-sdk-path`
export CC=`xcrun --sdk iphoneos -f clang`
export CXX=`xcrun --sdk iphoneos -f clang++`
export AS=`which gas-preprocessor.pl`
export AR=`xcrun --sdk iphoneos -f ar`
export RANLIB=`xcrun --sdk iphoneos -f ranlib`
export STRIP=`xcrun --sdk iphoneos -f strip`
export NM=`xcrun --sdk iphoneos -f nm`
# export CROSS_COMPILE=`xcode-select --print-path`/Toolchains/XcodeDefault.xctoolchain/usr/bin/
# export CROSS_TOP=`xcode-select --print-path`/Platforms/iPhoneOS.platform/Developer
# export CROSS_SDK=iPhoneOS.sdk
export OUTDIR="${PWD}/../out-ios"
IPHONEOS_DEPLOYMENT_TARGET="11.0"

function build(){
	ARCH=$1
	HOST=$2
	SDKDIR=$3
	export CFLAGS="-arch ${ARCH} -isysroot ${SDKDIR} -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET}"
	export CPPFLAGS=$CFLAGS
	export LDFLAGS="-arch ${ARCH} -isysroot ${SDKDIR} -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET}"

	./Configure $HOST --prefix=$OUTDIR/$ARCH
	make -j 4 && make install
	make clean
}
mkdir -p $OUTDIR
# build armv7   ios-cross   `xcrun --sdk iphoneos --show-sdk-path`
# build armv7s  armv7s  `xcrun --sdk iphoneos --show-sdk-path`
build arm64    ios64-cross    `xcrun --sdk iphoneos --show-sdk-path`
# build i386    i386   `xcrun --sdk iphonesimulator --show-sdk-path`
# build x86_64  iossimulator-xcrun  `xcrun --sdk iphonesimulator --show-sdk-path`

function combine(){
	LIBS=$1
	for LIB in $LIBS
	do
		rm -rf $OUTDIR/fat/$LIB
		lipo -create `find $OUTDIR -name $LIB` -output $OUTDIR/fat/$LIB
		lipo -info $OUTDIR/fat/$LIB
	done
}

mkdir -p $OUTDIR/fat
combine "libcrypto.a libssl.a"


