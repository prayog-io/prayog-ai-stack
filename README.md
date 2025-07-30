---
title: Deploy Your Complete AI Stack
description: Deploy a complete AI development environment with OpenWebUI, N8N workflow automation, Qdrant vector database, and PostgreSQL in minutes
---

**Powered by [Prayog.io](https://prayog.io)** - Your Ultimate AI Development Platform

This comprehensive guide will walk you through deploying a complete AI development environment that includes OpenWebUI for AI interactions, N8N for workflow automation, Qdrant vector database, PostgreSQL, and comprehensive monitoring with Grafana and Langfuse.

<!-- ![AI Stack Architecture](../../../assets/ai-stack/architecture-overview.jpg) -->

## ⚡ Super Quick Start (One Command!)

The fastest way to get your entire AI stack running:

```bash
git clone 
cd ai-stack-demo
./quick-start.sh
```

That's it! This single command sets up everything and gets you running in minutes.

## 🎯 What You Get Instantly

Your complete AI development environment includes:

- 🤖 **Open WebUI** (http://localhost:3000) - AI Chat Interface
- 📊 **Grafana Monitoring** (http://localhost:4000) - Infrastructure & System Monitoring  
- 🔍 **Langfuse** (http://localhost:3001) - LLM Observability & Analytics
- ⚡ **OpenWebUI Pipelines** (http://localhost:9099) - AI Pipeline Processing
- 🔄 **N8N with OpenTelemetry** (http://localhost:5678) - Workflow Automation + Observability
- 🗂️ **Qdrant** (http://localhost:6333) - Vector Database
- 🗄️ **PostgreSQL** (localhost:5433) - Relational Database

## Prerequisites

Before you begin, ensure you have the following set up:

1. **Docker and Docker Compose installed** - Download from the [official Docker website](https://docker.com)
2. **Git installed** - For cloning the repository
3. **8GB+ RAM recommended** - For optimal performance of all services
4. **Available ports** - Ensure ports 3000, 3001, 4000, 5433, 5678, 6333, and 9099 are available

## 🏗️ Architecture Overview

```
                           AI STACK ARCHITECTURE
                               
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   OpenWebUI     │    │    Grafana      │    │    Langfuse     │
│   (Port 3000)   │    │   (Port 4000)   │    │   (Port 3001)   │
│  AI Interface   │    │  Infrastructure │    │ LLM Analytics   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │              ┌─────────────────┐              │
         │              │      N8N        │              │
         │              │   (Port 5678)   │              │
         │              │ Workflow Engine │              │
         │              └─────────────────┘              │
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────────────┐
                    │      PostgreSQL         │
                    │     (Port 5433)         │
                    │   Shared Database       │
                    └─────────────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Pipelines     │    │     Qdrant      │    │  OpenTelemetry  │
│   (Port 9099)   │    │   (Port 6333)   │    │    (OTLP)       │
│ AI Processing   │    │ Vector Database │    │     Traces      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Step 1: Clone and Setup the Repository

First, clone the AI stack repository to your local machine:

```bash
git clone <your-repository-url>
cd ai-stack-demo
```

## Step 2: Configure Your Environment

Copy the example environment file and customize it for your needs:

```bash
# Copy the environment template
cp env.example .env

# Edit the configuration (optional)
nano .env
```

### Key Configuration Options

#### 🤖 AI Configuration
```bash
# For real OpenAI models (optional)
OPENAI_API_KEY=your_openai_api_key_here
OPENAI_API_BASE_URL=https://api.openai.com/v1

# Pipeline API (for custom processing)
PIPELINES_API_BASE_URL=http://host.docker.internal:9099
PIPELINES_API_KEY=0p3n-w3bu!
```

#### 📊 Monitoring Configuration
```bash
# Grafana
GRAFANA_PORT=4000
GRAFANA_ADMIN_PASSWORD=admin123

# Langfuse
LANGFUSE_PORT=3001
LANGFUSE_SECRET=change-in-production
```

#### 🗄️ Database Configuration
```bash
POSTGRES_USER=admin
POSTGRES_PASSWORD=adminpass
POSTGRES_PORT=5433
```

## Step 3: Start Your AI Stack

### Option A: Quick Start (Recommended)
```bash
./quick-start.sh
```

### Option B: Manual Startup
```bash
# Start all services
docker-compose up -d

# Check service status
docker ps
```

### Option C: Step-by-Step Startup
```bash
# 1. Configure domains
./configure-domains.sh

# 2. Start pipeline service
./start-pipeline-service.sh

# 3. Start main services
./start-openwebui.sh
```

## Step 4: Verify Your Installation

Check that all services are running properly:

```bash
# Check service status
./status.sh

# Test main endpoints
curl http://localhost:3000  # OpenWebUI
curl http://localhost:4000  # Grafana
curl http://localhost:3001  # Langfuse
curl http://localhost:9099  # Pipelines
```

## Step 5: Access Your Services

Once everything is running, access your services:

| Service | URL | Purpose | Default Login |
|---------|-----|---------|---------------|
| 🤖 **OpenWebUI** | http://localhost:3000 | AI Chat Interface | Sign up on first visit |
| 📊 **Grafana** | http://localhost:4000 | Infrastructure Monitoring | admin / admin123 |
| 🔍 **Langfuse** | http://localhost:3001 | LLM Observability | Create account on first visit |
| ⚡ **Pipelines** | http://localhost:9099 | AI Pipeline API | API Key: `0p3n-w3bu!` |
| 🔄 **N8N** | http://localhost:5678 | Workflow Automation | Setup on first visit |
| 🗂️ **Qdrant** | http://localhost:6333 | Vector Database API | API Key: `difyai123456` |

## Configuring AI Models

### Using OpenAI Models

To connect to OpenAI's models, update your `.env` file:

```bash
OPENAI_API_KEY=your_openai_api_key_here
OPENAI_API_BASE_URL=https://api.openai.com/v1
```

### Using Local Models with Ollama

If you want to use local models, install Ollama:

```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Pull a model
ollama pull llama3.1:8b

# Start Ollama server
ollama serve
```

Then update your OpenWebUI configuration to point to the local Ollama instance.

## Setting Up Monitoring and Observability

Your AI stack includes comprehensive monitoring with Grafana and Langfuse:

### Grafana Monitoring Setup

1. **Access Grafana**: Open http://localhost:4000
2. **Login**: Use admin / admin123
3. **View Dashboards**: Pre-configured dashboards for:
   - Infrastructure metrics (CPU, memory, disk)
   - Application metrics (N8N workflows, PostgreSQL performance)
   - OpenTelemetry traces (request tracing across services)

### Langfuse Analytics Setup

1. **Access Langfuse**: Open http://localhost:3001
2. **Create Account**: Sign up on first visit
3. **Get API Keys**: Navigate to Settings → API Keys
4. **Configure OpenWebUI Integration**: 
   - Go to OpenWebUI Settings
   - Add Langfuse API keys
   - Enable conversation tracking

<!-- ![Langfuse Dashboard](../../../assets/ai-stack/langfuse-dashboard.jpg) -->

## Pipeline Configuration

Your AI stack includes powerful pipeline processing capabilities:

### Available Pipelines

#### N8N Integration Pipeline
Connects OpenWebUI with N8N workflows for external processing:

```json
{
  "n8n_url": "http://localhost:5678/webhook-test/your-webhook-id",
  "n8n_bearer_token": "your-bearer-token",
  "input_field": "chatInput",
  "response_field": "output",
  "emit_interval": 2.0,
  "enable_status_indicator": true
}
```

#### Langfuse Monitoring Pipeline
Provides comprehensive LLM monitoring and analytics:

```json
{
  "langfuse_secret_key": "your-secret-key",
  "langfuse_public_key": "your-public-key",
  "langfuse_host": "http://langfuse:3000/",
  "insert_tags": true,
  "use_model_name_instead_of_id": true,
  "debug": true
}
```

### Testing Pipelines

```bash
cd pipelines
python3 test_pipelines.py
```

## Management Commands

Your AI stack includes convenient management scripts:

| Command | Description |
|---------|-------------|
| `./quick-start.sh` | 🚀 Start everything (one command) |
| `./status.sh` | 📊 Check service health |
| `./logs.sh` | 📋 View service logs |
| `./stop.sh` | 🛑 Stop all services |
| `./configure-domains.sh` | 🌐 Configure domains |

## Advanced Configuration

### Production Deployment

For production deployment, update your configuration:

```bash
# Update domains
WEBUI_DOMAIN=your-app.com
LANGFUSE_DOMAIN=https://langfuse.your-app.com
N8N_DOMAIN=https://n8n.your-app.com

# Update security settings
WEBUI_SECRET_KEY=$(openssl rand -base64 32)
WEBUI_JWT_SECRET_KEY=$(openssl rand -base64 32)
NEXTAUTH_SECRET=$(openssl rand -base64 32)
```

### Scaling Configuration

For high-load scenarios, adjust resource limits:

```yaml
# docker-compose.yml
services:
  openwebui:
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
```

## Troubleshooting

### Common Issues

#### Port Conflicts
```bash
# Check what's using the port
lsof -i :3000

# Change port in .env
WEBUI_PORT=3001
```

#### Service Connection Issues
```bash
# Restart all services
docker-compose down
docker-compose up -d

# Check service logs
docker-compose logs servicename
```

#### Pipeline Loading Issues
```bash
# Test pipelines
cd pipelines
python3 test_pipelines.py

# Check pipeline logs
docker logs pipeline-service
```

### Debug Mode

Enable debug logging:

```bash
# .env file
WEBUI_LOG_LEVEL=DEBUG
LANGFUSE_LOG_LEVEL=DEBUG
```

## Security Considerations

### Change Default Secrets

Always update default credentials:

```bash
# Generate secure secrets
openssl rand -base64 32  # For various secret keys
```

### Network Security

The stack uses isolated Docker networks for security:

```yaml
networks:
  ai-stack:
    driver: bridge
    internal: false
```

## API Reference

### OpenWebUI API
- **Base URL**: `http://localhost:3000`
- **Health Check**: `GET /health`

### Langfuse API
- **Base URL**: `http://localhost:3001`
- **Health Check**: `GET /api/public/health`

### Qdrant API
- **Base URL**: `http://localhost:6333`
- **Collections**: `GET /collections`

That's how you deploy your complete AI stack! You now have a powerful, production-ready AI development environment with comprehensive monitoring, workflow automation, and vector database capabilities.

## Next Steps

- Explore the OpenWebUI interface and create your first AI conversation
- Set up custom workflows in N8N for automation
- Monitor your AI interactions through Langfuse analytics
- Store and query embeddings using the Qdrant vector database
- Create custom pipelines for specialized AI processing

Your AI stack is now ready for development, testing, and production use!
