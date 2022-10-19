export MACOSX_DEPLOYMENT_TARGET=10.15

export CFLAGS="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}"
export CPPFLAGS=$CFLAGS
export LDFLAGS=$CFLAGS


./configure --prefix=$PWD/../out-mac && make -j 20 && make install