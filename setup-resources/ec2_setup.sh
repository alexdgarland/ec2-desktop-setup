#! /usr/bin/env bash

### BASED LOOSELY ON https://aws.amazon.com/premiumsupport/knowledge-center/connect-to-linux-desktop-from-windows/

if [ -z "$PASSWORD" ]; then

    echo "ERROR - Please set and export PASSWORD before running script!"

else

    # Set a password before we start logging everything to screen
    echo -e "${PASSWORD}\n${PASSWORD}" | (sudo passwd ubuntu)
    
    set -x
    
    # Tweak SSH-related settings
    sudo sysctl net.ipv4.ip_forward=1
    sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sudo /etc/init.d/ssh restart
      
    # Prepare for installations
    sudo add-apt-repository ppa:webupd8team/atom
    sudo DEBIAN_FRONTEND=noninteractive apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
    
    # Install and set up XRDP
    sudo apt-get -y install xrdp xfce4 xfce4-goodies tightvncserver
    echo xfce4-session> /home/ubuntu/.xsession
    sudo cp /home/ubuntu/.xsession /etc/skel
    sudo sed -i '0,/-1/s//ask-1/' /etc/xrdp/xrdp.ini
    # Install UK keyboard in a way that works with XRDP
    sudo mv $( dirname "${BASH_SOURCE[0]}" )/km-0809.ini /etc/xrdp/km-0809.ini
    sudo chown xrdp.xrdp /etc/xrdp/km-0809.ini
    sudo chmod 644 /etc/xrdp/km-0809.ini
    # Having done all that - restart the service
    sudo service xrdp restart    

    # Install other stuff we want on the box
    sudo apt-get -y install firefox gedit eclipse openjdk-8-jdk atom
    
    # Some stuff to set up for either SSH'ing to GitHub or sync'ing from local copies -
    # not sure on approach yet for getting repos!
    # Might throw this out altogether and just SCP a pre-genned private key from somewhere
    # with the public key already set up in GitHub
    cat /dev/zero | ssh-keygen -q -N ""
    mkdir ~/synced-repos
    
    printf "\n\n**** COMPLETED INSTALLATION - REBOOTING ****\n\n\n"
    sudo reboot
    
fi
