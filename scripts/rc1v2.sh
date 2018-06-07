#!/bin/bash
# Copyright © 2015-2018 Platina Systems, Inc. All rights reserved.
# Use of this source code is governed by the GPL-2 license described in the
# LICENSE file.

# update apt
rm /etc/apt/sources.list
echo -e "deb http://deb.debian.org/debian jessie main" > /etc/apt/sources.list
echo -e "deb-src http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list
echo -e "deb http://deb.debian.org/debian jessie-updates main" >> /etc/apt/sources.list
echo -e "deb-src http://deb.debian.org/debian jessie-updates main" >> /etc/apt/sources.list
echo -e "deb http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list
echo -e "deb-src http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list
apt-get update

# install apps
apt-get -y install sudo i2c-tools make gcc redis-tools libpci-dev libusb-dev libusb-1.0 git bison flex watchdog

# get new Kernel COMMENT OUT FOR NOW, PUT BACK IN ONCE BOOTC UPDATED
###cd ~/
###rm -rf usb
###rm linux-image-platina-mk1-4.11.0.deb
###wget http://172.16.2.23/downloads/20170901/linux-image-platina-mk1-4.13.0.deb
#wget http://downloads.platinasystems.com/v0.41/linux-image-platina-mk1-4.13.0.deb;`
#wget http://downloads.platinasystems.com/test/master/linux-image-4.13.0-platina-mk1-amd64_4.13-70-gb902a381cb53_amd64.deb;`

# get Goes
wget http://172.16.2.23/downloads/20170901/goes-platina-mk1-installer
#wget http://downloads.platinasystems.com/v0.41/goes-platina-mk1-installer;`
#wget http://downloads.platinasystems.com/test/master/goes-platina-mk1-installer;`
chmod 655 goes-platina-mk1-installer

# get Goes Config Files
wget http://172.16.2.23/WORK/goesd-platina-mk1-modprobe.conf
wget http://172.16.2.23/WORK/goesd-platina-mk1-modules.conf
wget http://172.16.2.23/WORK/goesd-platina-mk1-sysctl.conf
cp goesd-platina-mk1-modprobe.conf /etc/modprobe.d/goesd-platina-mk1-modprobe.conf
cp goesd-platina-mk1-modules.conf /etc/modules-load.d/goesd-platina-mk1-modules.conf
cp goesd-platina-mk1-sysctl.conf /etc/sysctl.d/goesd-platina-mk1-sysctl.conf

# install new Kernel and upgrade grub DITTO NO FOR NOW
###rm /boot/*
###dpkg -i linux-image-platina-mk1-4.13.0.deb
###update-grub

#TODO update bootc.cfg WITH NEW KERNEL NAME FOR NEXT SDA6 BOOT AS PART OF GOES

# enable watchdog
sed -i 's@#watchdog-device.*@watchdog-device     = /dev/watchdog@' /etc/watchdog.conf
sed -i 's@#RuntimeWatchdogSec.*@RuntimeWatchdogSec=30@' /etc/systemd/system.conf
sed -i 's@#ShutdownWatchdogSec.*@ShutdownWatchdogSec=2min@' /etc/systemd/system.conf

# clean up persistent net rules
rm /etc/udev/rules.d/70-persistent-net.rules

# install tools
mkdir ~/tools
cd ~/tools
wget http://downloads.platinasystems.com/tools/ioget
wget http://downloads.platinasystems.com/tools/ioset
wget http://downloads.platinasystems.com/tools/eeupdate64e
chmod 655 ioget
chmod 655 ioset
chmod 655 eeupdate64e
./eeupdate64e /NIC=1 /RW 0x110

# make vim friendly`
echo -e "set nocompatible" > ~/.vimrc 
echo -e "set backspace=2" >> ~/.vimrc

# get Flashrom and get new Coreboot
cd ~/
wget http://downloads.platinasystems.com/tools/flashrom
wget http://downloads.platinasystems.com/tools/platina-mk1.xml
chmod 655 flashrom
mv flashrom /usr/local/sbin/flashrom
mkdir -p /usr/local/share/flashrom/layouts
mv platina-mk1.xml /usr/local/share/flashrom/layouts
cd ~/
rm coreboot-platina-mk1.rom
wget http://172.16.2.23/downloads/20170901/coreboot-platina-mk1.rom
#wget http://172.16.2.23/WORK/coreboot-platina-mk1.rom;`

# install new Coreboot DITTO NO FOR NOW
###/usr/local/sbin/flashrom -p internal:boardmismatch=force -l /usr/local/share/flashrom/layouts/platina-mk1.xml -i bios -w coreboot-platina-mk1.rom -A -V
#~/tools/ioset 0x604 0x00
#~/tools/ioset 0x604 0x80
#~/tools/ioget 0x600
#~/tools/ioget 0x602
#~/tools/ioget 0x604
#/usr/local/sbin/flashrom -p internal:boardmismatch=force -l /usr/local/share/flashrom/layouts/platina-mk1.xml -i bios -w coreboot-platina-mk1.rom -A -V

goes uninstall

reboot
