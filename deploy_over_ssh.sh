#! /usr/bin/env bash

scp -r "$( dirname "${BASH_SOURCE[0]}" )/setup-resources/" ec2-desktop:/home/ubuntu

ssh ec2-desktop "export PASSWORD=$1 ; bash /home/ubuntu/setup-resources/ec2_setup.sh"
