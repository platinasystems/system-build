#!/usr/bin/make -f

machines+= test-amd64

test_amd64_help:= suitable for qemu-goes with example-amd64.vmlinuz

test_amd64_targets = test-amd64.cpio.xz

all+= $(test_amd64_targets)

define test_amd64_vars
$1: export GOARCH=amd64
$1: linux_config=kvmconfig
$1: machine=test-amd64
$1: main=github.com/platinasystems/go/main/goes-test
endef

$(eval $(call test_amd64_vars,test-amd64.cpio.xz))
