
#   git clone https://github.com/openssl/openssl.git
#	cd openssl 
#	git checkout OpenSSL_1_1_0i   # OpenSSL_1_1_1m


#  fixed remove so extension version Configurations/10-main.conf  android{ shared_extension => ".so",}

export ANDROID_NDK_HOME=/root/software/android/android-ndk-r14b
export PATH=$ANDROID_NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin:$PATH
export CROSS_SYSROOT=$ANDROID_NDK_HOME/platforms/android-21/arch-arm
export CROSS_COMPILE=arm-linux-androideabi-
make clean
./Configure android-armeabi -D__ANDROID_API__=21 --prefix=$PWD/../out32
make && make install
