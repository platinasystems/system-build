#!/usr/bin/make -f

machines+= platina-mk2-mc1-bmc

platina_mk2_mc1_bmc_help := Platina Systems Management Card 1 Baseboard Management Controller

platina_mk2_mc1_bmc_targets = goes-platina-mk2-mc1-bmc
platina_mk2_mc1_bmc_targets+= platina-mk2-mc1-bmc.cpio.xz
platina_mk2_mc1_bmc_targets+= platina-mk2-mc1-bmc.vmlinuz
platina_mk2_mc1_bmc_targets+= platina-mk2-mc1-bmc.dtb
platina_mk2_mc1_bmc_targets+= platina-mk2-mc1-bmc.u-boot.img

# NOTE don't build platina-mk2-mc1-bmc.u-boot.img w/ all b/c it needs sudo
all+= $(filter-out %.u-boot.img,$(platina_mk2_mc1_bmc_targets))

platina_mk2_mc1_bmc_uboot_env+='fdt_high=0xffffffff'
platina_mk2_mc1_bmc_uboot_env+='bootargs=console=ttymxc0,115200 quiet root=/dev/mmcblk0p1 rootfstype=ext4 rootwait rw init=/init ip=dhcp'
platina_mk2_mc1_bmc_uboot_env+='bootcmd=run eth_setup; ext2load mmc 0:1 0x82000000 /boot/zImage; ext2load mmc 0:1 0x88000000 /boot/platina-mk2-mc1-bmc.dtb; bootz 0x82000000 - 0x88000000'
platina_mk2_mc1_bmc_uboot_env+='eth_setup=mii device FEC; sleep 1; mii write 0x1e 0x10 0x0001; sleep 1; mii write 0x1e 0x18 0x004b; sleep 1; mii write 0x1e 0x11 0x5d01;'

define platina_mk2_mc1_bmc_vars
$1: arch=arm
$1: cross_compile=arm-linux-gnueabi-
$1: dtb=platina-mk2-mc1-bmc.dtb
$1: export GOARCH=arm
$1: export GOARM=7
$1: linux_config=arch/arm/configs/platina-mk2-mc1-bmc_defconfig
$1: machine=platina-mk2-mc1-bmc
$1: main=github.com/platinasystems/go/main/goes-platina-mk2-mc1-bmc
$1: stripper=arm-linux-gnueabi-strip
$1: vmlinuz=linux/platina-mk2-mc1-bmc/arch/arm/boot/zImage
$1: uboot_env=$(platina_mk2_mc1_bmc_uboot_env)
$1: uboot_defconfig=platina-mk2-mc1-bmc_qspi_defconfig
endef

$(eval $(call platina_mk2_mc1_bmc_vars,goes-platina-mk2-mc1-bmc))
$(eval $(call platina_mk2_mc1_bmc_vars,linux/platina-mk2-mc1-bmc/arch/arm/boot/zImage))
$(eval $(call platina_mk2_mc1_bmc_vars,platina-mk2-mc1-bmc.cpio.xz))
$(eval $(call platina_mk2_mc1_bmc_vars,platina-mk2-mc1-bmc.cpio.xz.u-boot))
$(eval $(call platina_mk2_mc1_bmc_vars,platina-mk2-mc1-bmc.vmlinuz))
$(eval $(call platina_mk2_mc1_bmc_vars,platina-mk2-mc1-bmc.dtb))
$(eval $(call platina_mk2_mc1_bmc_vars,u-boot/platina-mk2-mc1-bmc/.config))
$(eval $(call platina_mk2_mc1_bmc_vars,u-boot/platina-mk2-mc1-bmc/tools/mkimage))
$(eval $(call platina_mk2_mc1_bmc_vars,u-boot/platina-mk2-mc1-bmc/u-boot.imx))
$(eval $(call platina_mk2_mc1_bmc_vars,platina-mk2-mc1-bmc.u-boot.img))

$(foreach c,$(linux_configs),\
	$(eval $(call platina_mk2_mc1_bmc_vars,$(c)-platina-mk2-mc1-bmc)))
