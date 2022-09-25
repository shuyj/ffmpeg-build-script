#
#  git clone https://github.com/mstorsjo/fdk-aac.git  
#  git checkout v2.0.2
#
export NDK_ROOT=/root/software/android/android-ndk-r14b
ABI=armeabi-v7a
SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm
TOOLCHAIN=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin
TARGET=arm-linux-androideabi
CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=neon"
#export CFLAGS="-I$SYSROOT/usr/include --sysroot=$SYSROOT $CFLAGS"
export CFLAGS="-I$SYSROOT/usr/include -DFT_DISABLE_BROTLI=TRUE -DFT_DISABLE_HARFBUZZ=TRUE --sysroot=$SYSROOT"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="--sysroot=$SYSROOT"
export CROSS_PREFIX="$TOOLCHAIN/$TARGET-"
export PATH=$TOOLCHAIN:$PATH
make clean
./configure --host=arm-linux-androideabi --prefix=$PWD/../android32 --with-sysroot=$SYSROOT
make -j 4 && make install

