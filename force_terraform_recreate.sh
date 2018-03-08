#! /usr/bin/env bash

pushd $( dirname "${BASH_SOURCE[0]}" )/terraform
echo "yes" | terraform destroy
terraform apply -auto-approve
popd
