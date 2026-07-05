#!/usr/bin/env bash
#1.2 - 05jun2026
set -e

CONFIG=".env/deploy.json"
if [ ! -f "$CONFIG" ]; then
    echo "$CONFIG not found."
    exit 1
fi

version=""
imagename=$(jq -r '.imagename' "$CONFIG")
username=$(jq -r '.username' "$CONFIG")
buildFolder=""

sshStartRun=$(jq -r '.ssh.start' "$CONFIG")
sshUsername=$(jq -r '.ssh.username' "$CONFIG")
sshServer=$(jq -r '.ssh.server' "$CONFIG")
sshPath=$(jq -r '.ssh.path' "$CONFIG")
sshCommand=$(jq -r '.ssh.command' "$CONFIG")

# Only allow overriding the version
while getopts "v:b:" opt; do
    case $opt in
        v) version="$OPTARG" ;;
        b) buildFolder="$OPTARG" ;;
        *) exit 1 ;;
    esac
done

docker build \
    -t "$username/$imagename:$version" \
    -t "$username/$imagename:latest" \
    "$buildFolder"

docker push "$username/$imagename:$version"
docker push "$username/$imagename:latest"

echo "===================doSsh=$sshStartRun============================"

if [ "$sshStartRun" = "true" ]; then
ssh "$sshUsername@$sshServer" <<EOF
set -e
cd "$sshPath"
$sshCommand
EOF
fi

#{
#  "version": "1.0.1",
#  "imagename": "",
#  "username": "",
#  "ssh": {
#    "start": true,
#    "username": "",
#    "server": "",
#    "path": "",
#    "command": ""
#  }
#}