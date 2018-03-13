#! /usr/bin/env bash

GITHUB_PRIVATE_KEY=$1
GIT_CONFIG_FILE=$2

scp $GIT_CONFIG_FILE ec2-desktop:.gitconfig

scp ~/.ssh/$GITHUB_PRIVATE_KEY ec2-desktop:.ssh/github_private_key
ssh ec2-desktop "chmod 700 ~/.ssh/github_private_key"
scp $( dirname "${BASH_SOURCE[0]}" )/git_ssh_config ~/.ssh/config

ssh ec2-desktop "sudo apt-get -y install ruby-full"
ssh ec2-desktop "sudo gem install bundle"
scp -r $( dirname "${BASH_SOURCE[0]}" )/github-utils/ ec2-desktop
ssh ec2-desktop "cd ~/github-utils ; bundle install"
ssh ec2-desktop "mkdir ~/git"
