#
#  git clone https://github.com/FFmpeg/FFmpeg.git
#  git checkout n5.0.1
#
NDK_ROOT=/root/software/android/android-ndk-r14b
ARCH_ABI=arm64
SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm64
TARGET=aarch64-linux-android
TOOLCHAIN=$NDK_ROOT/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin
PREFIX=$PWD/../android64
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
CFLAGS="-I$SYSROOT/usr/include --sysroot=$SYSROOT"
CXXFLAGS="$CFLAGS"
export LDFLAGS="--sysroot=$SYSROOT -L$SYSROOT/usr/lib -lm"
CROSS_PREFIX="$TOOLCHAIN/$TARGET-"
export PATH=$TOOLCHAIN:$PATH

make clean

./configure --prefix=$PWD/../android64 --enable-cross-compile --arch=$ARCH_ABI --target-os=android --cross-prefix=$TARGET- --cc=aarch64-linux-android-gcc --sysroot=$SYSROOT  \
--enable-runtime-cpudetect --pkg-config=pkg-config --enable-pic --enable-stripping --enable-gpl --enable-nonfree --enable-shared --enable-static \
--enable-version3 --enable-pthreads --enable-small --disable-iconv --enable-neon --enable-asm --enable-inline-asm \
--enable-mediacodec --enable-jni --enable-hwaccels --enable-decoder=h264_mediacodec --enable-openssl --enable-libx264 --enable-libfdk_aac \
--disable-doc

make -j4 && make install

