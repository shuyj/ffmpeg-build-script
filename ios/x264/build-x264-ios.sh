#
#   git clone https://code.videolan.org/videolan/x264.git
#   git checkout baee400fa9ced6f5481a728138fed6e867b0ff7f      // latest for stable branch
#

SDK_HOME=`xcrun --sdk iphoneos --show-sdk-path`
export CC=`xcrun --sdk iphoneos -f clang`
export CXX=`xcrun --sdk iphoneos -f clang++`
export AS="`which gas-preprocessor.pl` -- $CC"
export AR=`xcrun --sdk iphoneos -f ar`
export RANLIB=`xcrun --sdk iphoneos -f ranlib`
export STRIP=`xcrun --sdk iphoneos -f strip`
export NM=`xcrun --sdk iphoneos -f nm`
export OUTDIR="${PWD}/../out-ios"
IPHONEOS_DEPLOYMENT_TARGET="11.0"

function build(){
	ARCH=$1
	HOST=$2
	SDKDIR=$3
	export CFLAGS="-arch ${ARCH} -isysroot ${SDKDIR} -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET}"
	export CPPFLAGS=$CFLAGS
	export ASFLAGS=$CFLAGS
	export LDFLAGS="-arch ${ARCH} -isysroot ${SDKDIR} -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET}"

	./configure --prefix=$OUTDIR/$ARCH --host=$HOST --enable-static --enable-lto --enable-pic --sysroot=$SDKDIR	\
	&& make -j 4 && make install
	make clean
}
mkdir -p $OUTDIR
# build armv7   armv7-apple-darwin   `xcrun --sdk iphoneos --show-sdk-path`
# build armv7s  armv7s  `xcrun --sdk iphoneos --show-sdk-path`
build arm64    arm64-apple-darwin    `xcrun --sdk iphoneos --show-sdk-path`
# build i386    i386   `xcrun --sdk iphonesimulator --show-sdk-path`
# build x86_64  x86_64  `xcrun --sdk iphonesimulator --show-sdk-path`

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
combine "libx264.a"







