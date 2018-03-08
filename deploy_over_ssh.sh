#! /usr/bin/env bash

for i in "$@"
do
case $i in
    -p=*|--password=*)
    PASSWORD="${i#*=}"
    shift
    ;;
    -k=*|--gitprivatekey=*)
    GIT_PRIVATE_KEY="${i#*=}"
    shift
    ;;
    *)
    ;;
esac
done

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )
LOG_DIR=$SCRIPT_DIR/install_logs
LOG_FILE=$LOG_DIR/`date '+%Y-%m-%d-%H%M%S'`.log

REMOTE_HOME=ec2-desktop:/home/ubuntu
scp -r "$GIT_PRIVATE_KEY" $REMOTE_HOME/.ssh/
scp -r "$SCRIPT_DIR/setup-resources/" $REMOTE_HOME/

mkdir -p $LOG_DIR
ssh ec2-desktop "export PASSWORD=$PASSWORD ; bash ~/setup-resources/ec2_setup.sh" 2>&1 | tee $LOG_FILE
