#!/bin/sh -e
# Copyright © 2015-2018 Platina Systems, Inc. All rights reserved.
# Use of this source code is governed by the GPL-2 license described in the
# LICENSE file.
#
# postinstall.sh
#
# This script is executed by rc.local the first time sda6
# boots after an automated re-install.
#
# This script installs goes, etc.
# This script is incorporated into postinstall.tar.gz

rm /postinstall.tar.gz
./rc1v2.sh
./rc2v2.sh

