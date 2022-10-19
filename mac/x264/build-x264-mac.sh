export MACOSX_DEPLOYMENT_TARGET=10.15

export CFLAGS="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}"
export CPPFLAGS=$CFLAGS
export LDFLAGS=$CFLAGS

#  去除 install_name
# configure     
# 1587 - -install_name @rpath/\$(SONAME)
# 1587 + -install_name \$(DESTDIR)\$(libdir)/\$(SONAME)
# 

./configure --prefix=$PWD/../out-mac --enable-static --enable-shared --enable-pic && make -j 20 && make install