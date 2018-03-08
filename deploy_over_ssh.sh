#! /usr/bin/env bash

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )
LOG_DIR=$SCRIPT_DIR/install_logs
LOG_FILE=$LOG_DIR/`date '+%Y-%m-%d-%H%M%S'`.log

scp -r "$SCRIPT_DIR/setup-resources/" ec2-desktop:/home/ubuntu

mkdir -p $LOG_DIR
ssh ec2-desktop "export PASSWORD=$1 ; bash ~/setup-resources/ec2_setup.sh" 2>&1 | tee $LOG_FILE
