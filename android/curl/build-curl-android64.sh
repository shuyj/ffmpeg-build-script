
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
#   git checkout curl-7_74_0    # curl-7_74_0    curl-7_81_0

export NDK_ROOT=/root/software/android/android-ndk-r14b
ABI=arm64
SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm64
TOOLCHAIN=$NDK_ROOT/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin
TARGET=aarch64-linux-android
#CFLAGS= 
export CFLAGS="-I$SYSROOT/usr/include --sysroot=$SYSROOT $CFLAGS"
export CROSS_PREFIX="$TOOLCHAIN/$TARGET-"
export PATH=$TOOLCHAIN:$PATH
export PKG_CONFIG_PATH=$PWD/../out64/lib/pkgconfig
make clean
./configure --prefix=$PWD/../out64 --host=aarch64-linux-android --with-sysroot=$CROSS_SYSROOT --with-pic --with-ssl="$PWD/../out64"
make && make install


##  注意： 64位编译curl命令时会找不到ssl和crypto库，实际是未加入-lssl -lcrypto  32位时没问题，可用下面命令编译过即可
#   bash 
#	source build-curl-android64.sh  出错无法链接ssl
#	make --trace   查看CCLD命令行
#   在命令的最后加入  -lssl -lcrypto   手动执行此命令
#   继续make 与  make install

