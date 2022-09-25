#
#  git clone https://github.com/FFmpeg/FFmpeg.git
#  git checkout n5.0.1
#
NDK_ROOT=/root/software/android/android-ndk-r14b
ARCH_ABI=arm
SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm
TARGET=arm-linux-androideabi
TOOLCHAIN=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin
PREFIX=$PWD/../android32
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
CFLAGS="-I$SYSROOT/usr/include --sysroot=$SYSROOT"
CXXFLAGS="$CFLAGS"
export LDFLAGS="--sysroot=$SYSROOT -L$SYSROOT/usr/lib -lm"
CROSS_PREFIX="$TOOLCHAIN/$TARGET-"
export PATH=$TOOLCHAIN:$PATH

make clean

./configure --prefix=$PWD/../android32 --enable-cross-compile --arch=$ARCH_ABI --target-os=android --cross-prefix=$TARGET- --cc=arm-linux-androideabi-gcc --sysroot=$SYSROOT  \
--enable-runtime-cpudetect --pkg-config=pkg-config --enable-pic --enable-stripping --enable-gpl --enable-nonfree --enable-shared --enable-static \
--enable-version3 --enable-pthreads --enable-small --disable-iconv --enable-neon --enable-asm --enable-inline-asm \
--enable-mediacodec --enable-jni --enable-hwaccels --enable-decoder=h264_mediacodec --enable-openssl --enable-libx264 --enable-libfdk_aac \
--disable-doc

make -j4 && make install

