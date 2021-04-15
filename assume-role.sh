#!/usr/bin/env bash

set -e

role=$1
if [ -z "${role}" ]; then
  echo "Role not set. Usage: <ROLE>"
  exit 1
fi

account=$(aws sts get-caller-identity | jq -r '.Account')

response=$(aws sts assume-role \
--role-arn "arn:aws:iam::${account}:role/${role}" \
--role-session-name "github-runner")

aws configure set aws_access_key_id $(echo $response | jq -r '.Credentials.AccessKeyId') --profile default
aws configure set aws_secret_access_key $(echo $response | jq -r '.Credentials.SecretAccessKey') --profile default
aws configure set aws_session_token $(echo $response | jq -r '.Credentials.SessionToken') --profile default