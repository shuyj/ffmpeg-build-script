
#export TOOLCHAIN=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
#export AR=$TOOLCHAIN/bin/arm-linux-androideabi-ar
#export AS=$TOOLCHAIN/bin/arm-linux-androideabi-as
#export CC=$TOOLCHAIN/bin/arm-linux-androideabi-gcc
#export CXX=$TOOLCHAIN/bin/arm-linux-androideabi-g++
#export LD=$TOOLCHAIN/bin/arm-linux-androideabi-ld
#export RANLIB=$TOOLCHAIN/bin/arm-linux-androideabi-ranlib
#export STRIP=$TOOLCHAIN/bin/arm-linux-androideabi-strip
#export CROSS_SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm

#   git clone https://github.com/curl/curl.git
#   cd curl
#   git checkout curl-7_74_0    # curl-7_81_0

export NDK_ROOT=/root/software/android/android-ndk-r14b
ABI=armeabi-v7a
SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm
TOOLCHAIN=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin
TARGET=arm-linux-androideabi
CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=neon"
export CFLAGS="-I$SYSROOT/usr/include --sysroot=$SYSROOT $CFLAGS"
export CROSS_PREFIX="$TOOLCHAIN/$TARGET-"
export PATH=$TOOLCHAIN:$PATH
export PKG_CONFIG_PATH=$PWD/../out32/lib/pkgconfig
make clean
./configure --prefix=$PWD/../out32 --host=arm-linux-androideabi --with-sysroot=$CROSS_SYSROOT --with-pic --with-ssl="$PWD/../out32"
make && make install


