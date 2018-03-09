#! /usr/bin/env bash

set -e

INSTALLATION_DIR=$( dirname "${BASH_SOURCE[0]}" )/installation

source $INSTALLATION_DIR/installer_functions.sh

function configure_ssh() {
  sudo sysctl net.ipv4.ip_forward=1
  sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
  sudo /etc/init.d/ssh restart
  chmod 700 ~/.ssh/github_private_key
  cp $INSTALLATION_DIR/remote_ssh_config ~/.ssh/config
}

if [ -z "$PASSWORD" ]; then
    echo "ERROR - Please set and export PASSWORD before running script!"
    exit 1
fi
echo -e "${PASSWORD}\n${PASSWORD}" | (sudo passwd ubuntu)

# Only turn on full command logging once password set!
set -x

configure_ssh
prepare_for_installs
setup_xrdp
install_applications

mkdir -p ~/git

cat $INSTALLATION_DIR/bashrc_additions.sh >> ~/.bashrc
cat $INSTALLATION_DIR/bash_profile_additions.sh >> ~/.bash_profile

printf "\n\n**** COMPLETED INSTALLATION - REBOOTING ****\n\n\n"
sudo reboot
