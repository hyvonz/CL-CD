#!/usr/bin/env bash
set -Eeuo pipefail

source "$(dirname "$0")/common.sh"

cd_project_root
require_command python3

log "Installing Python dependencies"
python3 -m pip install --user -r app/requirements.txt

log "Running pytest test suite"
python3 -m pytest test

log "Unit tests passed"
