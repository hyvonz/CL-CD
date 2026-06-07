IMAGE_NAME ?= cicd-demo
IMAGE_TAG ?= latest

.PHONY: check test build deploy-test deploy-prod smoke-test smoke-prod status

check:
	./scripts/ci/check_toolchain.sh

test:
	./scripts/ci/run_unit_tests.sh

build:
	IMAGE_NAME=$(IMAGE_NAME) IMAGE_TAG=$(IMAGE_TAG) ./scripts/ci/build_image.sh

deploy-test:
	IMAGE_TAG=$(IMAGE_TAG) ./scripts/ci/deploy_environment.sh test

deploy-prod:
	IMAGE_TAG=$(IMAGE_TAG) ./scripts/ci/deploy_environment.sh prod

smoke-test:
	./scripts/ci/smoke_test.sh test

smoke-prod:
	./scripts/ci/smoke_test.sh prod

status:
	IMAGE_NAME=$(IMAGE_NAME) ./scripts/ci/show_deployment_state.sh
