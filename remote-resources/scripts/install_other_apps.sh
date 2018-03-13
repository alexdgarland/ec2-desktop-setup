#! /usr/bin/env bash

APP_LIST_FILE=/tmp/remote-resources/config/other_apps.txt

sudo apt-get -y install $(cat $APP_LIST_FILE | tr -d "\015" | tr "\n" " ")
