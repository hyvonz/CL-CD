# Container CI/CD Demo App

本项目用于演示基于 Jenkins 与 Docker 的容器化 CI/CD 流水线。

## 项目结构

- `app/`: Flask Web 应用源代码。
- `test/`: Pytest 自动化测试脚本。
- `Dockerfile`: 应用镜像构建文件。
- `docker-compose.test.yml`: 测试环境部署配置。
- `docker-compose.prod.yml`: 生产环境部署配置。
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

应用支持以下环境变量：
APP_ENV: 设置运行环境名称（如 Testing / Production）。Env环境变量存储在`.env`文件中，使用dotenv读取。
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

## Jenkins 流水线

流水线阶段如下：

1. `Checkout`: 从 Git 仓库拉取代码。
2. `Unit Test`: 安装依赖并执行 Pytest。
3. `Docker Build`: 构建 Docker 镜像。
4. `Deploy to Test`: 使用 Docker Compose 部署测试环境。
5. `Smoke Test`: 调用测试环境 `/health` 接口做冒烟测试。
6. `Deploy to Production`: 人工确认后部署生产环境，并再次检查 `/health`。

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
