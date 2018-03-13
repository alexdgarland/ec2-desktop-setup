#! /usr/bin/env bash

sudo DEBIAN_FRONTEND=noninteractive apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get -y \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold" \
  dist-upgrade
