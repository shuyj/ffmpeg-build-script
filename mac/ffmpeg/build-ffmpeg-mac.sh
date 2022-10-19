export MACOSX_DEPLOYMENT_TARGET=10.15

export CFLAGS="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}"
export CPPFLAGS=$CFLAGS
export LDFLAGS=$CFLAGS

PKG_CONFIG_PATH=$PWD/../out-mac/lib/pkgconfig ./configure --prefix=/Users/shuyj/code/temp/FFmpeg/ffmpeg/../out-mac \
--enable-rpath --enable-runtime-cpudetect --enable-gpl --enable-nonfree --enable-static \
--enable-version3 --enable-pthreads --disable-iconv --enable-asm --enable-inline-asm --enable-videotoolbox --enable-audiotoolbox \
--enable-hwaccels --enable-openssl --enable-libx264 --enable-libfdk_aac --disable-doc --disable-devices --disable-metal --disable-htmlpages \
--disable-manpages --disable-podpages --disable-txtpages --disable-programs --install-name-dir=@rpath && make -j20 && make install

# --disable-stripping --enable-debug --disable-optimizations
