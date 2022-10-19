LIB=$1
SELFLIB=`otool -L $LIB | awk -F ' ' '{ if (NR == 2) print $1;}'`
LIBS=`otool -L $LIB | awk -F ' ' '{ if (NR > 2) print $1;}'`

echo ==DEBUG==SELF=$SELFLIB==
	if [ x$SELFLIB != x${SELFLIB#/Users} ]; then
		new=${SELFLIB##*/}
		echo $SELFLIB, $new
		echo install_name_tool -id @rpath/$new $LIB
		install_name_tool -id @rpath/$new  $LIB
	fi

echo ==DEBUG==$LIBS==
for lib in $LIBS
do
	if [ $lib != ${lib#/Users} ]; then
		new=${lib##*/}
		echo $lib, $new
		echo install_name_tool -change $lib @rpath/$new  $LIB
		install_name_tool -change $lib @rpath/$new  $LIB
	fi
done
