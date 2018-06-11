#!/bin/bash
# Copyright © 2015-2018 Platina Systems, Inc. All rights reserved.
# Use of this source code is governed by the GPL-2 license described in the
# LICENSE file.

# install iproute
cd ~/
wget --no-check-certificate https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-4.13.0.tar.gz
tar -xvf iproute2-4.13.0.tar.gz
cd iproute2-4.13.0
make install
cd ..
rm -rf iproute2-4.13.0
rm iproute2-4.13.0.tar.gz

# install Goes
# echo -e "#!/usr/bin/goes\n! ifup --allow vnet -a" > /etc/goes/start
# wget http://192.168.101.127/goes-platina-mk1-installer
# wget http://downloads.platinasystems.com/v0.4/goes-platina-mk1-installer
# wget http://downloads.platinasystems.com/v0.41/goes-platina-mk1-installer
wget http://172.16.2.23:/downloads/goes-platina-mk1-installer
chmod 655 goes-platina-mk1-installer
./goes-platina-mk1-installer
goes status;
goes hget platina package | grep version:

# switch to bmc
#goes stop
#goes toggle

