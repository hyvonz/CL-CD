#!/usr/bin/env bash
set -Eeuo pipefail

source "$(dirname "$0")/common.sh"

cd_project_root
require_command docker

log "Current demo containers"
docker ps --filter "name=cicd-demo" \
  --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

log "Recent demo images"
docker image ls "$(image_name)" \
  --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}\t{{.Size}}"
