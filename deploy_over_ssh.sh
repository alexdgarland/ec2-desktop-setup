#! /usr/bin/env bash

ssh ec2-desktop "export PASSWORD=$1 ; bash -s " < $( dirname "${BASH_SOURCE[0]}" )/remote_scripts/ec2_setup.sh
