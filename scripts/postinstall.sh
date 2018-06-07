#!/bin/sh -e
#
# postinstall.sh
#
# This script is executed by rc.local the first time sda6
# boots after an automated re-install.
#
# This script installs goes, etc.
# This script is incorporated into postinstall.tar.gz

./rc1v2.sh
./rc2v2.sh

