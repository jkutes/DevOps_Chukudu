#!/bin/bash

# export aws creds to env

# init - to get TF AWS provider and modules
# terrraform init

# test
terraform plan -var-file terraform-prod.tfvars

# run
# terraform apply -var-file terraform-prod.tfvars -auto-approve

