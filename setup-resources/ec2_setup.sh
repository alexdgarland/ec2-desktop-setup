#! /usr/bin/env bash

source $( dirname "${BASH_SOURCE[0]}" )/installation/installer_functions.sh

function configure_ssh() {
  sudo sysctl net.ipv4.ip_forward=1
  sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
  sudo /etc/init.d/ssh restart
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

printf "\n\n**** COMPLETED INSTALLATION - REBOOTING ****\n\n\n"
sudo reboot
