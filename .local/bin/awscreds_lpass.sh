#!/usr/bin/env bash

# Sample credentials file
# [default]
# credential_process = sh -c "$HOME/.local/bin/awscreds_lpass.sh aws_creds"

readonly lastPassEntry=$1
readonly accessKeyId=$(lpass show --username "$lastPassEntry")
readonly secretAccessKey=$(lpass show --password "$lastPassEntry")

# Create JSON object that AWS CLI expects
jq -n \
    --arg accessKeyId "$accessKeyId" \
    --arg secretAccessKey "$secretAccessKey" \
    '.Version = 1
    | .AccessKeyId = $accessKeyId
    | .SecretAccessKey = $secretAccessKey'

