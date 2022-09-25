#   git clone https://github.com/openssl/openssl.git
#	cd openssl 
#	git checkout OpenSSL_1_1_0i   # OpenSSL_1_1_1m

export ANDROID_NDK_HOME=/root/software/android/android-ndk-r14b
export PATH=$ANDROID_NDK_HOME/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin:$PATH
export CROSS_SYSROOT=$ANDROID_NDK_HOME/platforms/android-21/arch-arm64
export CROSS_COMPILE=aarch64-linux-android-
make clean
./Configure android64-aarch64 -D__ANDROID_API__=21 --prefix=$PWD/../out64
make && make install
