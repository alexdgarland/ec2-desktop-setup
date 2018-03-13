#! /usr/bin/env bash

for i in "$@"
do
  case $i in
    -k=*|--private-key=*)
    PRIVATE_KEY="${i#*=}"
    shift
    ;;
    -c=*|--gitconfig=*)
    GITCONFIG="${i#*=}"
    shift
    ;;
    -u=*|--username=*)
    USERNAME="${i#*=}"
    shift
    ;;
    -p=*|--password=*)
    PASSWORD="${i#*=}"
    shift
    ;;
    *)
    ;;
  esac
done

scp $GITCONFIG ec2-desktop:.gitconfig

scp ~/.ssh/$PRIVATE_KEY ec2-desktop:.ssh/github_private_key
ssh ec2-desktop "chmod 700 ~/.ssh/github_private_key"
scp $( dirname "${BASH_SOURCE[0]}" )/git_ssh_config ec2-desktop:~/.ssh/config

ssh ec2-desktop "sudo apt-get -y install ruby-full"
ssh ec2-desktop "sudo gem install bundle"
scp -r $( dirname "${BASH_SOURCE[0]}" )/github-utils/ ec2-desktop:~
ssh ec2-desktop "cd ~/github-utils ; bundle install"

ssh ec2-desktop "~/github-utils/clone-all-repos.rb -u $USERNAME -p $PASSWORD"
