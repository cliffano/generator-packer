#!/bin/bash
set -o errexit
set -o nounset

docker --version
make clean deps lint build-docker
cat logs/packer-build-docker.log
echo "${DOCKERHUB_TOKEN}" | docker login --username {{github_id}} --password-stdin
docker inspect {{github_id}}/{{project_id}}
make publish-docker