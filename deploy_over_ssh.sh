#! /usr/bin/env bash

set -eu

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

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
    -c=*|--gitconfig=*)
    GIT_CONFIG_FILE="${i#*=}"
    shift
    ;;
    *)
    ;;
esac
done

echo "Deploying GitHub private key $GITHUB_PRIVATE_KEY"
scp ~/.ssh/$GITHUB_PRIVATE_KEY ec2-desktop:.ssh/github_private_key
echo "Deploying Git Config $GIT_CONFIG_FILE"
scp $GIT_CONFIG_FILE ec2-desktop:.gitconfig

scp -r "$SCRIPT_DIR/setup-resources/" ec2-desktop:setup-resources/

LOG_DIR=$SCRIPT_DIR/install_logs
mkdir -p $LOG_DIR

LOG_FILE=$LOG_DIR/`date '+%Y-%m-%d-%H%M%S'`.log

ssh ec2-desktop "export PASSWORD=$PASSWORD ; bash ~/setup-resources/ec2_setup.sh" 2>&1 | tee $LOG_FILE

set +eu
