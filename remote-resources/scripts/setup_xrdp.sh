#! /usr/bin/env bash

RESOURCE_DIR=/tmp/remote-resources/

sudo apt-get -y install xrdp xfce4 xfce4-goodies tightvncserver
echo xfce4-session >> ~/.xsession
sudo cp ~/.xsession /etc/skel
sudo sed -i '0,/-1/s//ask-1/' /etc/xrdp/xrdp.ini

mkdir ~/.wallpaper
cp $RESOURCE_DIR/config/wallpaper.png ~/.wallpaper/wallpaper.png
sudo cp $RESOURCE_DIR/scripts/set_wallpaper.sh /usr/local/bin/
sudo cp $RESOURCE_DIR/config/set-wallpaper.desktop /etc/xdg/autostart/

# Install UK keyboard in a way that works with XRDP
sudo mv $RESOURCE_DIR/config/km-0809.ini /etc/xrdp/km-0809.ini
sudo chown xrdp.xrdp /etc/xrdp/km-0809.ini
sudo chmod 644 /etc/xrdp/km-0809.ini

# Fix terminal autocomplete bug in XFCE
sudo sed -i 's/switch_window_key/empty/' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml

sudo service xrdp restart
