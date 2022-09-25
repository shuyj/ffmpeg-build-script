#
#   git clone https://code.videolan.org/videolan/x264.git
#   git checkout baee400fa9ced6f5481a728138fed6e867b0ff7f      // latest for stable branch
#
export NDK_ROOT=/root/software/android/android-ndk-r14b
ABI=armeabi-v7a
SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm
TOOLCHAIN=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin
TARGET=arm-linux-androideabi
#CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=neon"
#export CFLAGS="-I$SYSROOT/usr/include --sysroot=$SYSROOT $CFLAGS"
export CFLAGS="-I$SYSROOT/usr/include --sysroot=$SYSROOT"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="--sysroot=$SYSROOT"
export CROSS_PREFIX="$TOOLCHAIN/$TARGET-"
export PATH=$TOOLCHAIN:$PATH

make clean
./configure --prefix=$PWD/../android32 --host=arm-linux --enable-shared --enable-pic --cross-prefix=arm-linux-androideabi- --sysroot=$SYSROOT 
make -j4 && make install
