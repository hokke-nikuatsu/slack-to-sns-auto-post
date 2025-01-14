#!/bin/bash

export $(grep -v '^#' terraform.tfvars | sed 's/ *= */=/' | xargs)

aws_account_id=$(aws --profile $aws_profile sts get-caller-identity --query 'Account' --output text)

lambda_function_name=$(terraform output -raw lambda_function_name)

aws --profile $aws_profile --region $aws_region lambda update-function-code --function-name $lambda_function_name --image-uri $aws_account_id.dkr.ecr.$aws_region.amazonaws.com/$resource_name:latest
