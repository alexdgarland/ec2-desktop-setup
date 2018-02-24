#! /usr/bin/env bash

### BASED LOOSELY ON https://aws.amazon.com/premiumsupport/knowledge-center/connect-to-linux-desktop-from-windows/

if [ -z "$PASSWORD" ]; then

    echo "ERROR - Please set and export PASSWORD before running script!"

else

    echo -e "${PASSWORD}\n${PASSWORD}" | (sudo passwd ubuntu)
    
    cat /dev/zero | ssh-keygen -q -N ""
    
    set -x
    
    sudo add-apt-repository ppa:webupd8team/atom
    
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
    sudo apt update && sudo apt upgrade

    sudo sysctl net.ipv4.ip_forward=1
    

    sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sudo /etc/init.d/ssh restart
    
    sudo apt-get -y install xrdp xfce4 xfce4-goodies tightvncserver firefox gedit eclipse openjdk-8-jdk atom
    echo xfce4-session> /home/ubuntu/.xsession
    sudo cp /home/ubuntu/.xsession /etc/skel
    sudo sed -i '0,/-1/s//ask-1/' /etc/xrdp/xrdp.ini

    # Install UK keyboard in a way that works with XRDP
    sudo curl http://c-nergy.be/downloads/km-0809_v1.1.ini > km-0809.ini
    sudo mv km-0809.ini /etc/xrdp/
    sudo chown xrdp.xrdp /etc/xrdp/km-0809.ini
    sudo chmod 644 /etc/xrdp/km-0809.ini

    sudo service xrdp restart    

    printf "\n\n**** COMPLETED INSTALLATION - REBOOTING ****\n\n\n"
    
    sudo reboot
    
fi
