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
  sudo cp $RESOURCE_DIR/set_wallpaper.sh /usr/local/bin/
  sudo cp $RESOURCE_DIR/set-wallpaper.desktop /etc/xdg/autostart/
  echo xfce4-session >> ~/.xsession
  sudo cp ~/.xsession /etc/skel
  sudo sed -i '0,/-1/s//ask-1/' /etc/xrdp/xrdp.ini
  # Install UK keyboard in a way that works with XRDP
  sudo mv $RESOURCE_DIR/km-0809.ini /etc/xrdp/km-0809.ini
  sudo chown xrdp.xrdp /etc/xrdp/km-0809.ini
  sudo chmod 644 /etc/xrdp/km-0809.ini
  # Fix terminal autocomplete bug in XFCE
  KB_CONF=/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
  sudo sed -i 's/switch_window_key/empty/' $KB_CONF
  # Restart service
  sudo service xrdp restart
}

function configure_atom() {
  sudo cp /usr/lib/x86_64-linux-gnu/libxcb.so.1 /opt/atom/
  sudo sed -i 's/BIG-REQUESTS/_IG-REQUESTS/' /opt/atom/libxcb.so.1
  mkdir -p ~/.atom/
  cat $RESOURCE_DIR/atom_keymap_additions.cson >> ~/.atom/keymap.cson
}

function install_applications() {
  app_list_file=$RESOURCE_DIR/apps.txt
  sudo apt-get -y install $(cat $app_list_file | tr -d "\015" | tr "\n" " ")
  if cat $app_list_file | tr -d "\015" | egrep ^atom$  ; then
    configure_atom
  fi
  sudo -H pip install --upgrade pip
  sudo -H pip install --upgrade virtualenv
  sudo gem install bundle
  pushd $RESOURCE_DIR/../github-utils/
  bundle install
  popd
}
