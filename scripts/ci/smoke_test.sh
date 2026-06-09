#!/usr/bin/env bash
set -Eeuo pipefail

source "$(dirname "$0")/common.sh"

ENVIRONMENT_NAME="${1:-}"
[[ -n "${ENVIRONMENT_NAME}" ]] || fail "Usage: scripts/ci/smoke_test.sh <test|prod>"

cd_project_root
require_command curl

URL="$(health_url_for "${ENVIRONMENT_NAME}")"
MAX_RETRIES="${SMOKE_RETRIES:-10}"
SLEEP_SECONDS="${SMOKE_INTERVAL:-2}"

log "Running smoke test for ${ENVIRONMENT_NAME}: ${URL}"

for attempt in $(seq 1 "${MAX_RETRIES}"); do
  if curl --noproxy "*" -fsS "${URL}"; then
    printf '\n'
    log "Smoke test passed on attempt ${attempt}"
    exit 0
  fi

  log "Smoke test attempt ${attempt}/${MAX_RETRIES} failed; retrying in ${SLEEP_SECONDS}s"
  sleep "${SLEEP_SECONDS}"
done

fail "Smoke test failed after ${MAX_RETRIES} attempts: ${URL}"
