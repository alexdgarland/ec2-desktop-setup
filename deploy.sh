#! /usr/bin/env bash

set -eu

for i in "$@"
do
  case $i in
    -p=*|--password=*)
      PASSWORD="${i#*=}"
      shift
      ;;
    *)
      ;;
  esac
done

LOG_DIR=$( dirname "${BASH_SOURCE[0]}" )/install_logs/`date '+%Y-%m-%d-%H%M%S'`
mkdir -p $LOG_DIR

ssh ec2-desktop "echo -e \"${PASSWORD}\n${PASSWORD}\" | (sudo passwd ubuntu)"

scp -r $( dirname "${BASH_SOURCE[0]}" )/remote-resources/ ec2-desktop:/tmp/remote-resources/

function exec_remote_script {
  script_name=$1
  ssh ec2-desktop ". /tmp/remote-resources/scripts/$script_name.sh" 2>&1 | tee $LOG_DIR/$script_name.log
}

exec_remote_script "configure_ssh"
exec_remote_script "prepare_aptget"
exec_remote_script "setup_xrdp"
exec_remote_script "install_atom"
exec_remote_script "install_python"
exec_remote_script "install_other_apps"
exec_remote_script "setup_bashrc"

ssh ec2-desktop "rm -rf /tmp/remote-resources/"

printf "\n\n**** COMPLETED INSTALLATION - REBOOTING ****\n\n\n"
ssh ec2-desktop "sudo reboot"

set +eu
