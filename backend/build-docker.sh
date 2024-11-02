#!/bin/bash

export $(grep -v '^#' terraform.tfvars | sed 's/ *= */=/' | xargs)

aws_account_id=$(aws --profile $aws_profile sts get-caller-identity --query 'Account' --output text)

# Docker login
aws --profile $aws_profile --region $aws_region ecr get-login-password | docker login --username AWS --password-stdin $aws_account_id.dkr.ecr.$aws_region.amazonaws.com

# Build image
docker build --platform linux/amd64 --provenance=false -t $aws_account_id.dkr.ecr.$aws_region.amazonaws.com/$resource_name .

# Push image
docker push $aws_account_id.dkr.ecr.$aws_region.amazonaws.com/$resource_name
