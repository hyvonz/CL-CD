#!/usr/bin/env bash
set -Eeuo pipefail

source "$(dirname "$0")/common.sh"

ENVIRONMENT_NAME="${1:-}"
[[ -n "${ENVIRONMENT_NAME}" ]] || fail "Usage: scripts/ci/deploy_environment.sh <test|prod>"

cd_project_root
require_command docker

COMPOSE_FILE="$(compose_file_for "${ENVIRONMENT_NAME}")"
IMAGE_TAG_VALUE="$(image_tag)"

log "Deploying ${ENVIRONMENT_NAME} environment with ${COMPOSE_FILE}"
IMAGE_TAG="${IMAGE_TAG_VALUE}" docker compose -f "${COMPOSE_FILE}" up -d

log "Deployment command completed"
docker compose -f "${COMPOSE_FILE}" ps
