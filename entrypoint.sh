#!/bin/sh

registration_url="https://github.com/${GITHUB_ORG_NAME}"
token_url="https://api.github.com/orgs/${GITHUB_ORG_NAME}/actions/runners/registration-token"
payload=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" ${token_url})
export RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)

./config.sh --url https://github.com/${GITHUB_OWNER} --token ${RUNNER_TOKEN}

remove() {
   ./config.sh remove --unattended --token "${RUNNER_TOKEN}"
}

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM

./run.sh "$*" &

wait $!