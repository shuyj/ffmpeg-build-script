
#   git clone https://github.com/openssl/openssl.git
#	cd openssl 
#	git checkout OpenSSL_1_1_0i


export MACOSX_DEPLOYMENT_TARGET=10.15

export CFLAGS="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}"
export CPPFLAGS=$CFLAGS
export LDFLAGS=$CFLAGS


#  remove install_name
# Configurations/shared-info.pl  -install_name @rpath/


make clean
./Configure darwin64-x86_64-cc --prefix=$PWD/../out-mac
make && make install

