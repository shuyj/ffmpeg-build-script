export PATH=$ANDROID_NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin:$PATH
export CC=arm-linux-androideabi-gcc
export LD=arm-linux-androideabi-ld
export AR=arm-linux-androideabi-ar

FDKAAC_FLAGS="--host=arm-linux-androideabi \
  --enable-static"

SYSROOT=$ANDROID_NDK/platforms/android-9/arch-arm
PREFIX=`pwd`/build/android && mkdir -p $PREFIX
FDKAAC_FLAGS="$FDKAAC_FLAGS --prefix=$PREFIX"

export CFLAGS="--sysroot=$SYSROOT -O3 -Wall -pipe -std=c99 -ffast-math -fstrict-aliasing -Werror=strict-aliasing -Wno-psabi -Wa,--noexecstack \
    -DANDROID -DNDEBUG -march=armv7-a -mtune=cortex-a8 -mfpu=vfpv3-d16 -mfloat-abi=softfp -mthumb -Wno-sequence-point -Wno-extra"
#-ffunction-sections -mfpu=neon -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__

export CPP="arm-linux-androideabi-gcc -E --sysroot=$SYSROOT"
export CXXCPP="arm-linux-androideabi-g++ -E --sysroot=$SYSROOT"

export LDFLAGS="-Wl,--fix-cortex-a8"

export CXXFLAGS="--sysroot=$SYSROOT -std=c++98"

./configure $FDKAAC_FLAGS #| tee $PREFIX/configuration.txt
  cp config.* $PREFIX
  [ $PIPESTATUS == 0 ] || exit 1

#make clean
make -j4 || exit 1
make install || exit 1