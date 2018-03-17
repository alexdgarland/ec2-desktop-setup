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

REMOTE_TMP=/tmp/remote-resources/

scp -r $( dirname "${BASH_SOURCE[0]}" )/remote-resources/ ec2-desktop:$REMOTE_TMP

exec_idx=1

function exec_remote_command {
  cmd=$1
  log_name=$2
  ssh ec2-desktop "$cmd" 2>&1 | tee $LOG_DIR/$exec_idx-$log_name.log
  exec_idx=$((exec_idx+1))
}

function exec_remote_bash_script {
  script_name=$1
  exec_remote_command ". $REMOTE_TMP/scripts/$script_name.sh" $script_name
}

function exec_create_airflow_user {
  cmd="python $REMOTE_TMP/scripts/create_airflow_user.py -u airflow -p $PASSWORD"
  exec_remote_command "$cmd" "create_airflow_user"
}

exec_remote_bash_script "configure_ssh"
exec_remote_bash_script "prepare_aptget"
exec_remote_bash_script "setup_xrdp"
exec_remote_bash_script "install_atom"
exec_remote_bash_script "install_python"
exec_remote_bash_script "install_airflow"
exec_create_airflow_user
exec_remote_bash_script "install_other_apps"

printf "\n\n**** COMPLETED INSTALLATION - REBOOTING ****\n\n\n"
ssh ec2-desktop "sudo reboot"

set +eu
