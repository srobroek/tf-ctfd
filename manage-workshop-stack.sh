#!/bin/bash

STACK_OPERATION=$1
export TF_VAR_region=$AWS_DEFAULT_REGION
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
if [[ "$STACK_OPERATION" == "create" || "$STACK_OPERATION" == "update" ]]; then
  terraform init
  terraform apply -y

    # deploy / update workshop resources
elif [ "$STACK_OPERATION" == "delete" ]; then
  terraform destroy -y
    # delete workshop resources
else
    echo "Invalid stack operation!"
    exit 1
fi