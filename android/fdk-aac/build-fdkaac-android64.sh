#
#  git clone https://github.com/mstorsjo/fdk-aac.git  
#  git checkout v2.0.2
#
export NDK_ROOT=/root/software/android/android-ndk-r14b
ABI=arm64-v8a
SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm64
TOOLCHAIN=$NDK_ROOT/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin
TARGET=aarch64-linux-android
CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=neon"
#export CFLAGS="-I$SYSROOT/usr/include --sysroot=$SYSROOT $CFLAGS"
export CFLAGS="-I$SYSROOT/usr/include -DFT_DISABLE_BROTLI=TRUE -DFT_DISABLE_HARFBUZZ=TRUE --sysroot=$SYSROOT"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="--sysroot=$SYSROOT"
export CROSS_PREFIX="$TOOLCHAIN/$TARGET-"
export PATH=$TOOLCHAIN:$PATH
make clean
./configure --host=aarch64-linux-android --prefix=$PWD/../android64 --with-sysroot=$SYSROOT
make -j 4 && make install

