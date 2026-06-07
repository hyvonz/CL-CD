# Container CI/CD Demo App

本项目用于演示基于 Jenkins 与 Docker 的容器化 CI/CD 流水线。

## 项目结构

- `app/`: Flask Web 应用源代码。
- `test/`: Pytest 自动化测试脚本。
- `Dockerfile`: 应用镜像构建文件。
- `docker-compose.test.yml`: 测试环境部署配置。
- `docker-compose.prod.yml`: 生产环境部署配置。
- `scripts/ci/`: Jenkins 和本地复用的 CI/CD 脚本。
- `Makefile`: 本地执行测试、构建、部署和查看状态的快捷入口。
- `Jenkinsfile`: Jenkins Pipeline 流水线定义。

## 技术栈

- Python Flask: 示例 Web 服务。
- Pytest: 单元测试和接口测试。
- Docker: 应用容器化封装。
- Docker Compose: 测试环境和生产环境部署。
- Jenkins Pipeline: 自动化构建、测试和发布。

## 本地运行

```bash
python3 -m pip install -r app/requirements.txt
APP_ENV=Local-Dev python3 app/main.py
```

访问首页：

```bash
curl --noproxy "*" http://localhost:5000/
```

健康检查：

```bash
curl --noproxy "*" http://localhost:5000/health
```

## 本地测试

```bash
python3 -m pytest test
```

测试通过后，说明应用的首页、健康检查接口和版本接口可以正常访问。

## Docker 镜像构建

```bash
docker build -t cicd-demo:latest .
```

运行容器：

```bash
docker run --rm -p 5000:5000 -e APP_ENV=Local-Docker cicd-demo:latest
```

## Docker Compose 部署

部署测试环境：

```bash
IMAGE_TAG=latest docker compose -f docker-compose.test.yml up -d
```

访问测试环境：

```bash
curl --noproxy "*" http://localhost:18080/health
```

部署生产环境：

```bash
IMAGE_TAG=latest docker compose -f docker-compose.prod.yml up -d
```

访问生产环境：

```bash
curl --noproxy "*" http://localhost:28080/health
```

## CI 脚本说明

`scripts/ci/` 目录把流水线中的 shell 命令拆成了独立脚本，便于本地调试和 Jenkins 复用。

- `common.sh`: 公共函数，负责日志输出、文件检查、命令检查和环境映射。
- `check_toolchain.sh`: 检查项目文件、Python、Docker、Compose 和 curl 是否可用。
- `run_unit_tests.sh`: 安装 Python 依赖并运行 Pytest。
- `build_image.sh`: 构建 Docker 镜像并写入镜像标签。
- `deploy_environment.sh`: 按参数部署测试环境或生产环境。
- `smoke_test.sh`: 请求 `/health` 接口，验证部署后的服务可用性。
- `show_deployment_state.sh`: 打印容器和镜像状态，便于 Jenkins 日志展示。

## Makefile 快捷命令

```bash
make check
make test
make build IMAGE_TAG=demo
make deploy-test IMAGE_TAG=demo
make smoke-test
make deploy-prod IMAGE_TAG=demo
make smoke-prod
make status
```

## Jenkins 流水线

流水线阶段如下：

1. `Checkout`: 从 Git 仓库拉取代码。
2. `Prepare`: 检查脚本权限、关键文件和基础命令。
3. `Unit Test`: 安装依赖并执行 Pytest。
4. `Docker Build`: 构建 Docker 镜像。
5. `Deploy to Test`: 使用 Docker Compose 部署测试环境。
6. `Smoke Test`: 调用测试环境 `/health` 接口做冒烟测试。
7. `Deploy to Production`: 人工确认后部署生产环境，并再次检查 `/health`。

## 演示步骤

1. 修改 `app/main.py` 中的 `APP_VERSION`。
2. 提交并推送代码到远程 Git 仓库。
3. 在 Jenkins 中启动或等待触发 Pipeline。
4. 查看 Jenkins 构建日志，确认测试、构建和部署阶段执行成功。
5. 访问 `http://localhost:18080/` 查看测试环境页面。
6. 点击 Jenkins 人工确认后，访问 `http://localhost:28080/` 查看生产环境页面。

## 环境变量

- `APP_ENV`: 控制页面和健康检查接口显示的运行环境。
- `IMAGE_TAG`: 控制 Docker Compose 部署时使用的镜像标签。
