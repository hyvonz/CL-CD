#!/usr/bin/env bash
set -Eeuo pipefail

source "$(dirname "$0")/common.sh"

cd_project_root

log "Checking required project files"
require_file "app/main.py"
require_file "app/requirements.txt"
require_file "test/test_health.py"
require_file "Dockerfile"
require_file "docker-compose.test.yml"
require_file "docker-compose.prod.yml"

log "Checking required commands"
require_command python3
require_command docker
require_command curl

docker compose version >/dev/null 2>&1 || fail "Docker Compose plugin is not available"

log "Toolchain check passed"
