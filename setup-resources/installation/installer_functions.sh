#! /usr/bin/env bash

RESOURCE_DIR=$( dirname "${BASH_SOURCE[0]}" )


function prepare_for_installs() {
  sudo add-apt-repository ppa:webupd8team/atom

  sudo DEBIAN_FRONTEND=noninteractive apt-get update

  sudo DEBIAN_FRONTEND=noninteractive apt-get -y \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    dist-upgrade
}

function setup_xrdp() {

  sudo apt-get -y install xrdp xfce4 xfce4-goodies tightvncserver
  echo xfce4-session > /home/ubuntu/.xsession
  sudo cp /home/ubuntu/.xsession /etc/skel
  sudo sed -i '0,/-1/s//ask-1/' /etc/xrdp/xrdp.ini

  # Install UK keyboard in a way that works with XRDP
  KM_FILE=km-0809.ini
  KM_PATH=/etc/xrdp/$KM_FILE
  sudo mv $RESOURCE_DIR/$KM_FILE $KM_PATH
  sudo chown xrdp.xrdp $KM_PATH
  sudo chmod 644 $KM_PATH

  # Fix terminal autocomplete bug in XFCE
  XFCE_CONF_DIR=/etc/xdg/xfce4/xfconf/xfce-perchannel-xml
  KB_CONF=$XFCE_CONF_DIR/xfce4-keyboard-shortcuts.xml
  sudo cp $KB_CONF $KB_CONF.bak
  sudo sed -i 's/switch_window_key/empty/' $KB_CONF

  # Having done all that - restart the service
  sudo service xrdp restart
}

function configure_atom() {
  sudo cp /usr/lib/x86_64-linux-gnu/libxcb.so.1 /opt/atom/
  sudo sed -i 's/BIG-REQUESTS/_IG-REQUESTS/' /opt/atom/libxcb.so.1
}

function install_applications() {
  app_list_file=$RESOURCE_DIR/apps.txt
  sudo apt-get -y install $(cat $app_list_file | tr -d "\015" | tr "\n" " ")
  if cat $app_list_file | tr -d "\015" | egrep ^atom$  ; then
    configure_atom
  fi
  sudo -H pip install --upgrade pip
  sudo -H pip install --upgrade virtualenv
}
