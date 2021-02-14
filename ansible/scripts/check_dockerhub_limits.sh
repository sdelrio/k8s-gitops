#!/bin/bash

# https://docs.docker.com/docker-hub/download-rate-limit/


echo " * Checking with no registration"
echo

TOKEN=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:ratelimitpreview/test:pull" | jq -r .token)
curl --head -s -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/ratelimitpreview/test/manifests/latest

echo " * Checking with docker account"
echo

DOCKER_USER=$(cat ~/.docker/config.json |grep '"auth":'| cut -f2 -d :| sed 's/[ ]*"//g'|base64 -d|cut -f 1 -d :)
DOCKER_PASS=$(cat ~/.docker/config.json |grep '"auth":'| cut -f2 -d :| sed 's/[ ]*"//g'|base64 -d|cut -f 2 -d :)

TOKEN=$(curl -s --user "${DOCKER_USER}:${DOCKER_PASS}" "https://auth.docker.io/token?service=registry.docker.io&scope=repository:ratelimitpreview/test:pull" | jq -r .token)
curl --head -s -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/ratelimitpreview/test/manifests/latest

