#!/bin/sh
board=`basename $BASE_DIR`
goes=../../goes-$board
test -x $goes || goes=../../goes-boot
cp $goes $1/usr/bin/goes
$HOST_DIR/usr/bin/$HOSTARCH-linux-strip $1/usr/bin/goes
rm -f $1/init
rm -f $1/sbin/init
ln -s usr/bin/goes $1/init
ln -s usr/bin/goes $1/sbin/init
rm -f $1/etc/resolv.conf
echo "nameserver 8.8.8.8" >$1/etc/resolv.conf
exit 0
