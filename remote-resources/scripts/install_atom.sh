#! /usr/bin/env bash

sudo add-apt-repository ppa:webupd8team/atom
sudo DEBIAN_FRONTEND=noninteractive apt-get update

sudo apt-get -y install atom

sudo cp /usr/lib/x86_64-linux-gnu/libxcb.so.1 /opt/atom/
sudo sed -i 's/BIG-REQUESTS/_IG-REQUESTS/' /opt/atom/libxcb.so.1

mkdir -p ~/.atom/
cat /tmp/remote-resources/config/atom_keymap_additions.cson >> ~/.atom/keymap.cson
