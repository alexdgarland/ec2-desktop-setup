#! /usr/bin/env BASH_SOURCE

sudo sysctl net.ipv4.ip_forward=1

sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

sudo /etc/init.d/ssh restart
