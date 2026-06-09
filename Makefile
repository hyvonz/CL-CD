.PHONY: help install run test docker-run

help:
	@echo "可用命令:"
	@echo "  make install    - 安装本地开发环境依赖"
	@echo "  make test       - 运行本地 pytest 测试"
	@echo "  make dev-run    - 以开发模式启动应用"
	@echo "  make docker-up  - 使用 Docker Compose 启动测试环境"

install:
	pip install -r app/requirements.txt

test:
	pytest test/

dev-run:
	export APP_ENV=testing && python3 app/main.py

docker-up:
	docker compose -f docker-compose.test.yml up -d