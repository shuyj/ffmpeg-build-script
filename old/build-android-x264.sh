export PATH=$ANDROID_NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin:$PATH
export CC=arm-linux-androideabi-gcc
export LD=arm-linux-androideabi-ld
export AR=arm-linux-androideabi-ar

X264_FLAGS="--host=arm-linux \
  --cross-prefix=arm-linux-androideabi-	\
  --enable-pic	\
  --enable-static"

SYSROOT=$ANDROID_NDK/platforms/android-9/arch-arm
PREFIX=`pwd`/build/android_x264 && mkdir -p $PREFIX
X264_FLAGS="$X264_FLAGS --prefix=$PREFIX"

EXTRA_CFLAGS="-O3 -Wall -pipe -std=c99 -ffast-math -fstrict-aliasing -Werror=strict-aliasing -Wno-psabi -Wa,--noexecstack \
	-DANDROID -DNDEBUG -march=armv7-a -mtune=cortex-a8 -mfpu=vfpv3-d16 -mfloat-abi=softfp -mthumb"
#-ffunction-sections -mfpu=neon -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__

EXTRA_LDFLAGS="-Wl,--fix-cortex-a8"

./configure $X264_FLAGS --sysroot=$SYSROOT --extra-cflags="$EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS" #| tee $PREFIX/configuration.txt
  cp config.* $PREFIX
  [ $PIPESTATUS == 0 ] || exit 1

  make clean
  make -j4 || exit 1
  make install || exit 1
