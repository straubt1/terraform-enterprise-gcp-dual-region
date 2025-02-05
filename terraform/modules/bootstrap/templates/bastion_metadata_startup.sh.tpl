#!/bin/bash
set -euo pipefail

exec &> >(tee -a /var/log/metadata_startup.log)
echo "metadata_startup_start"
apt-get update -y
echo "metadata_startup_end"
