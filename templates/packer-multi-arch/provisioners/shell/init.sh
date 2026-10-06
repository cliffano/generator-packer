#!/bin/sh
set -o errexit
set -o nounset

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ansible
apt-get clean
