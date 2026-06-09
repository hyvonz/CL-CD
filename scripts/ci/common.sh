#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

log() {
  printf '[ci] %s\n' "$*"
}

fail() {
  printf '[ci][error] %s\n' "$*" >&2
  exit 1
}

require_command() {
  local command_name="$1"
  command -v "${command_name}" >/dev/null 2>&1 || fail "Required command not found: ${command_name}"
}

require_file() {
  local file_path="$1"
  [[ -f "${PROJECT_ROOT}/${file_path}" ]] || fail "Required file not found: ${file_path}"
}

compose_file_for() {
  local environment_name="$1"

  case "${environment_name}" in
    test)
      printf '%s\n' "docker-compose.test.yml"
      ;;
    prod|production)
      printf '%s\n' "docker-compose.prod.yml"
      ;;
    *)
      fail "Unknown environment: ${environment_name}. Expected test or prod."
      ;;
  esac
}

health_url_for() {
  local environment_name="$1"

  case "${environment_name}" in
    test)
      printf '%s\n' "${TEST_URL:-http://localhost:18080/health}"
      ;;
    prod|production)
      printf '%s\n' "${PROD_URL:-http://localhost:28080/health}"
      ;;
    *)
      fail "Unknown environment: ${environment_name}. Expected test or prod."
      ;;
  esac
}

image_name() {
  printf '%s\n' "${IMAGE_NAME:-cicd-demo}"
}

image_tag() {
  printf '%s\n' "${IMAGE_TAG:-latest}"
}

cd_project_root() {
  cd "${PROJECT_ROOT}"
}
