# Container CI/CD Demo - API 接口文档

本文档定义了 **Container CI/CD Demo** 应用暴露的外部接口，供开发者调试及 Jenkins 流水线（冒烟测试）调用。

## 1. 基础信息

- **基本 URL**: `http://<host>:<port>`
- **测试环境端口**: `18080`
- **生产环境端口**: `28080`
- **数据格式**: `JSON` (除首页外)

---

## 2. 接口列表

### 2.1 访问首页 (Index)

获取应用的运行状态及环境信息，主要用于人工可视化验证。

- **URL**: `/`
- **请求方法**: `GET`
- **身份验证**: 无
- **参数**: 无
- **返回内容**: `HTML`
- **返回示例**:

  ```html
  <h1>Container CI/CD Demo</h1>
  <p>Status: Running</p>
  <p>Version: v1.0.0</p>
  <p>Environment: production</p>
  ```

---

### 2.2 健康检查 (Health Check)

用于自动化监控工具（如 Jenkins, Docker Compose）检测应用是否已准备就绪。

- **URL**: `/health`
- **请求方法**: `GET`
- **参数**: 无
- **返回数据说明**:

  | 字段 | 类型 | 说明 |
  | :--- | :--- | :--- |
  | `status` | String | 运行状态，正常返回 "ok" |
  | `env` | String | 当前应用运行的环境标识 |

- **返回示例 (200 OK)**:

  ```json
  {
    "status": "ok",
    "env": "test"
  }
  ```

---

### 2.3 版本查询 (Version)

获取当前部署的应用版本号，用于验证 CI/CD 流水线是否发布了正确的版本。

- **URL**: `/version`
- **请求方法**: `GET`
- **参数**: 无
- **返回数据说明**:

  | 字段 | 类型 | 说明 |
  | :--- | :--- | :--- |
  | `version` | String | 语义化版本号（如 v1.0.0） |

- **返回示例 (200 OK)**:

  ```json
  {
    "version": "v1.0.0"
  }
  ```

---

## 3. 错误处理

本应用遵循标准 HTTP 状态码：

- `200 OK`: 请求成功。
- `404 Not Found`: 访问了不存在的接口。
- `500 Internal Server Error`: 服务器内部逻辑错误。
