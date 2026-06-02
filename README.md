# Container CI/CD Demo App

本项目是一个用于演示 Jenkins CI/CD 流水线的示例 Web 应用。

## 1. 项目结构

- `app/`: 存放 Python Web 应用源代码
- `test/`: 存放自动化测试脚本
- `Dockerfile`: 用于构建应用的容器镜像
- `docker-compose.*.yml`: 不同环境的容器编排配置
- `Jenkinsfile`: 定义流水线逻辑

## 2. 技术栈

- **后端框架**: Python Flask
- **自动化测试**: Pytest
- **容器化**: Docker / Docker Compose
- **持续集成**: Jenkins

## 3. 本地开发与运行

确保本地已安装 Python 3.8+。

### 安装依赖

```bash
cd app
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
export APP_ENV=Local-Dev
python3 main.py
```

访问：`http://localhost:5000`

### 4. API 接口说明

GET /: 查看应用当前运行状态、版本和环境。
GET /health: 健康检查接口（用于流水线验证）。
GET /version: 获取当前版本号。

### 5. 环境变量配置

应用支持以下环境变量：
APP_ENV: 设置运行环境名称（如 Testing / Production）。Env环境变量存储在`.env`文件中，使用dotenv读取。
