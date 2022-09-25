export PATH=$ANDROID_NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin:$PATH
export CC=arm-linux-androideabi-gcc
export LD=arm-linux-androideabi-ld
export AR=arm-linux-androideabi-ar

SYSROOT=$ANDROID_NDK/platforms/android-9/arch-arm

PREFIX=`pwd`/build/android_rtmp && mkdir -p $PREFIX

make CROSS_COMPILE=arm-linux-androideabi- INC=-I$SYSROOT/usr/include prefix=$PREFIX XCFLAGS="-DNO_CRYPTO --sysroot=$SYSROOT" XLDFLAGS="--sysroot=$SYSROOT" $1
