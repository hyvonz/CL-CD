#!/usr/bin/env bash
set -Eeuo pipefail

source "$(dirname "$0")/common.sh"

cd_project_root
require_command docker

IMAGE_NAME_VALUE="$(image_name)"
IMAGE_TAG_VALUE="$(image_tag)"

log "Building Docker image ${IMAGE_NAME_VALUE}:${IMAGE_TAG_VALUE}"
docker build \
  --label "ci.project=container-cicd-demo" \
  --label "ci.image=${IMAGE_NAME_VALUE}" \
  --label "ci.tag=${IMAGE_TAG_VALUE}" \
  -t "${IMAGE_NAME_VALUE}:${IMAGE_TAG_VALUE}" \
  -t "${IMAGE_NAME_VALUE}:latest" \
  .

log "Image build completed"
docker image ls "${IMAGE_NAME_VALUE}" --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
