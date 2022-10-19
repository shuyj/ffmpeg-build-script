export MACOSX_DEPLOYMENT_TARGET=10.15

export CFLAGS="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}"
export CPPFLAGS=$CFLAGS
export LDFLAGS=$CFLAGS

./configure --prefix=$PWD/../out-mac

# 去除 rpath
# 修改 Makefile 
# 1489  -rpath $(libdir)  为 -rpath @rpath
# 修改 libtool
# 删除 7330 对rpath检查
# We need an absolute path.
#   case $arg in
#   [\\/]* | [A-Za-z]:[\\/]*) ;;
#   *)
#     func_fatal_error "only absolute run-paths are allowed"
#     ;;
#   esac
read -p "change done ?"

make -j 20 && make install

