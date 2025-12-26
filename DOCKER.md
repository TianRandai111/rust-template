# Docker 部署指南 / Docker Deployment Guide

[English version below](#english-version)

## 中文版本

本项目包含了 VictoriaMetrics 监控栈的完整 Docker 配置，包括：

- **VictoriaMetrics**: 时间序列数据库，用于存储指标数据
- **VictoriaLogs**: 日志管理系统
- **VictoriaTraces**: 分布式追踪系统

### 快速开始

#### 1. 使用 docker-compose（推荐）

启动所有服务：

```bash
docker compose up -d
```

查看运行状态：

```bash
docker compose ps
```

查看日志：

```bash
docker compose logs -f
```

停止所有服务：

```bash
docker compose down
```

停止服务并删除数据卷：

```bash
docker compose down -v
```

#### 2. 单独运行服务

如果你只需要运行特定的服务，可以使用以下命令：

**VictoriaMetrics:**

```bash
docker run -d --name victoriametrics -p 8428:8428 \
  -v vmdata:/victoria-metrics-data \
  victoriametrics/victoria-metrics:latest \
  -storageDataPath=/victoria-metrics-data
```

**VictoriaLogs:**

```bash
docker run -d --name victorialogs -p 9428:9428 \
  -v victoria-logs-data:/victoria-logs-data \
  docker.io/victoriametrics/victoria-logs:latest \
  -storageDataPath=/victoria-logs-data
```

**VictoriaTraces:**

```bash
docker run -d --name victoriatraces -p 10428:10428 \
  -v victoria-traces-data:/victoria-traces-data \
  docker.io/victoriametrics/victoria-traces:latest \
  -storageDataPath=/victoria-traces-data
```

### 服务端口

- VictoriaMetrics: http://localhost:8428
- VictoriaLogs: http://localhost:9428
- VictoriaTraces: http://localhost:10428

### 数据持久化

所有服务的数据都通过 Docker 卷进行持久化存储：

- `vmdata`: VictoriaMetrics 数据
- `victoria-logs-data`: VictoriaLogs 数据
- `victoria-traces-data`: VictoriaTraces 数据

### 配置说明

#### docker-compose.yml

该文件定义了完整的服务栈，包括：

- 所有三个 Victoria 服务
- 自定义网络配置
- 数据卷配置

### 常用命令

```bash
# 重启特定服务
docker compose restart victoriametrics

# 查看特定服务的日志
docker compose logs -f victoriametrics

# 进入容器内部
docker compose exec victoriametrics sh

# 更新服务
docker compose pull
docker compose up -d
```

---

## English Version

This project includes a complete Docker configuration for the VictoriaMetrics monitoring stack, including:

- **VictoriaMetrics**: Time-series database for storing metrics
- **VictoriaLogs**: Log management system
- **VictoriaTraces**: Distributed tracing system

### Quick Start

#### 1. Using docker-compose (Recommended)

Start all services:

```bash
docker compose up -d
```

Check service status:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs -f
```

Stop all services:

```bash
docker compose down
```

Stop services and remove data volumes:

```bash
docker compose down -v
```

#### 2. Running Services Individually

If you only need to run specific services, use these commands:

**VictoriaMetrics:**

```bash
docker run -d --name victoriametrics -p 8428:8428 \
  -v vmdata:/victoria-metrics-data \
  victoriametrics/victoria-metrics:latest \
  -storageDataPath=/victoria-metrics-data
```

**VictoriaLogs:**

```bash
docker run -d --name victorialogs -p 9428:9428 \
  -v victoria-logs-data:/victoria-logs-data \
  docker.io/victoriametrics/victoria-logs:latest \
  -storageDataPath=/victoria-logs-data
```

**VictoriaTraces:**

```bash
docker run -d --name victoriatraces -p 10428:10428 \
  -v victoria-traces-data:/victoria-traces-data \
  docker.io/victoriametrics/victoria-traces:latest \
  -storageDataPath=/victoria-traces-data
```

### Service Ports

- VictoriaMetrics: http://localhost:8428
- VictoriaLogs: http://localhost:9428
- VictoriaTraces: http://localhost:10428

### Data Persistence

All service data is persisted using Docker volumes:

- `vmdata`: VictoriaMetrics data
- `victoria-logs-data`: VictoriaLogs data
- `victoria-traces-data`: VictoriaTraces data

### Configuration Details

#### docker-compose.yml

This file defines the complete service stack, including:

- All three Victoria services
- Custom network configuration
- Volume configuration

### Common Commands

```bash
# Restart a specific service
docker compose restart victoriametrics

# View logs for a specific service
docker compose logs -f victoriametrics

# Enter container shell
docker compose exec victoriametrics sh

# Update services
docker compose pull
docker compose up -d
```
