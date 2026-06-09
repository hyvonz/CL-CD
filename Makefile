# var definition
IMAGE_NAME ?= cicd-demo
IMAGE_TAG ?= latest

# phony target
.PHONY: help install test dev-run build deploy-test deploy-prod smoke-test status clean

# help cmd
help:
	@echo "--- 开发者与 CI 维护手册 ---"
	@echo "本地开发命令:"
	@echo "  make install      - 安装本地环境依赖"
	@echo "  make dev-run      - 本地快速启动调试 (Testing 环境)"
	@echo "  make test         - 运行单元测试"
	@echo ""
	@echo "CI/CD 部署命令 (调用 CI 脚本):"
	@echo "  make build        - 构建 Docker 镜像"
	@echo "  make deploy-test  - 部署到测试环境"
	@echo "  make deploy-prod  - 部署到生产环境"
	@echo "  make smoke-test   - 运行冒烟测试"
	@echo "  make status       - 查看当前部署状态"

# local dev cmd
install:
	pip install -r app/requirements.txt

dev-run:
	export APP_ENV=testing && python3 app/main.py

# cmd for constructing cl cd
test:
	@if [ -d "./scripts/ci" ]; then ./scripts/ci/run_unit_tests.sh; else pytest test/; fi

build:
	IMAGE_NAME=$(IMAGE_NAME) IMAGE_TAG=$(IMAGE_TAG) ./scripts/ci/build_image.sh

deploy-test:
	IMAGE_TAG=$(IMAGE_TAG) ./scripts/ci/deploy_environment.sh test

deploy-prod:
	IMAGE_TAG=$(IMAGE_TAG) ./scripts/ci/deploy_environment.sh prod

smoke-test:
	./scripts/ci/smoke_test.sh test

status:
	IMAGE_NAME=$(IMAGE_NAME) ./scripts/ci/show_deployment_state.sh

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +