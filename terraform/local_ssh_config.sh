#! /usr/bin/env bash

hostname=$1
keypair_name=$2

echo "Host ec2-desktop
    HostName $hostname
    User ubuntu
    IdentityFile ~/.ssh/$keypair_name.pem
    StrictHostKeyChecking No

Host ec2-desktop-portforward
    HostName $hostname
    User ubuntu
    IdentityFile ~/.ssh/$keypair_name.pem
    StrictHostKeyChecking No
    LocalForward 3388 localhost:3389"
