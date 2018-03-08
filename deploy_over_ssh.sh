#! /usr/bin/env bash

set -eu

for i in "$@"
do
case $i in
    -p=*|--password=*)
    PASSWORD="${i#*=}"
    shift
    ;;
    -k=*|--github-private-key=*)
    GITHUB_PRIVATE_KEY="${i#*=}"
    shift
    ;;
    *)
    ;;
esac
done

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )
LOG_DIR=$SCRIPT_DIR/install_logs
LOG_FILE=$LOG_DIR/`date '+%Y-%m-%d-%H%M%S'`.log

scp ~/.ssh/$GITHUB_PRIVATE_KEY ec2-desktop:.ssh/github_private_key
scp -r "$SCRIPT_DIR/setup-resources/" ec2-desktop:setup-resources/

mkdir -p $LOG_DIR
ssh ec2-desktop "export PASSWORD=$PASSWORD ; bash ~/setup-resources/ec2_setup.sh" 2>&1 | tee $LOG_FILE

set +eu
