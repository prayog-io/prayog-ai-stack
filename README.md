# PRAYOG : AI Stack DEMO

A complete AI development environment with OpenWebUI, N8N workflow automation, Qdrant vector database, and PostgreSQL.

**Powered by [Prayog.io](https://prayog.io)** - Your Ultimate AI Development Platform

## ⚡ Super Quick Start (One Command!)

```bash
./quick-start.sh
```

That's it! This single command sets up everything and gets you running in minutes.

## 🎯 What You Get Instantly

- 🤖 **Open WebUI** (http://localhost:3000) - AI Chat Interface
- 📊 **Grafana Monitoring** (http://localhost:4000) - Infrastructure & System Monitoring
- 🔍 **Langfuse** (http://localhost:3001) - LLM Observability & Analytics
- ⚡ **OpenWebUI Pipelines** (http://localhost:9099) - AI Pipeline Processing
- 🔄 **N8N with OpenTelemetry** (http://localhost:5678) - Workflow Automation + Observability
- 🗂️ **Qdrant** (http://localhost:6333) - Vector Database
- 🗄️ **PostgreSQL** (localhost:5433) - Relational Database

## 🛠️ Management Commands

| Command | Description |
|---------|-------------|
| `./quick-start.sh` | 🚀 Start everything (one command) |
| `./status.sh` | 📊 Check service health |
| `./logs.sh` | 📋 View service logs |
| `./stop.sh` | 🛑 Stop all services |

📖 **See [QUICK-START-GUIDE.md](QUICK-START-GUIDE.md) for detailed instructions and troubleshooting.**

---

## 📋 Legacy Documentation

### Alternative Setup (Step by Step)

### 1. Configure Domains
```bash
./configure-domains.sh
```

### 2. Start Services
```bash
./start-pipeline-service.sh
```

### 3. Access Services
- **OpenWebUI**: http://localhost:8080
- **Langfuse Dashboard**: http://localhost:3000
- **Ollama API**: http://localhost:11434

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Installation](#installation)
- [Configuration](#configuration)
- [Pipeline Integration](#pipeline-integration)
- [Domain Configuration](#domain-configuration)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)
- [API Reference](#api-reference)

## 🎯 Overview

This AI stack provides a complete development environment with:

- **OpenWebUI**: Web interface for LLM interactions
- **Grafana**: Infrastructure monitoring and observability 
- **Langfuse**: LLM-specific monitoring and analytics
- **OpenWebUI Pipelines**: Custom AI pipeline processing
- **N8N**: Workflow automation with OpenTelemetry
- **Qdrant**: Vector database for embeddings
- **PostgreSQL**: Shared database for all services

## ✨ Features

### 🤖 AI Services
- ✅ **OpenWebUI** - Modern AI chat interface
- ✅ **Pipeline Processing** - Custom AI transformations
- ✅ **OpenAI API Support** - External AI model integration
- ✅ **Vector Database** - Qdrant for embeddings

### 📊 Complete Observability
- ✅ **Grafana Monitoring** - Infrastructure metrics & traces
- ✅ **Langfuse Analytics** - LLM conversation tracking
- ✅ **OpenTelemetry** - Distributed tracing
- ✅ **Real-time Dashboards** - System health monitoring

### 🔄 Workflow Automation
- ✅ **N8N Integration** - Visual workflow builder
- ✅ **Database Automation** - PostgreSQL workflows
- ✅ **AI Pipeline Triggers** - Automated AI processing
- ✅ **Cross-service Communication** - Secure Docker networking

### 🛡️ Production Ready
- ✅ **Environment Variables** - Flexible configuration
- ✅ **Health Checks** - Service monitoring
- ✅ **Data Persistence** - Volume management
- ✅ **Security** - Isolated networks

## 🏗️ Architecture

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

## 🌐 Service Access

Once running, access your services at:

| Service | URL | Purpose | Login |
|---------|-----|---------|-------|
| 🤖 **OpenWebUI** | http://localhost:3000 | AI Chat Interface | Sign up on first visit |
| 📊 **Grafana** | http://localhost:4000 | Infrastructure Monitoring | admin / admin123 |
| 🔍 **Langfuse** | http://localhost:3001 | LLM Observability | Create account on first visit |
| ⚡ **Pipelines** | http://localhost:9099 | AI Pipeline API | API Key: `0p3n-w3bu!` |
| 🔄 **N8N** | http://localhost:5678 | Workflow Automation | Setup on first visit |
| 🗂️ **Qdrant** | http://localhost:6333 | Vector Database API | API Key: `difyai123456` |

## 📦 Installation

### Prerequisites
- Docker and Docker Compose
- Git
- 8GB+ RAM (recommended for all services)

### Quick Start (Recommended)
```bash
git clone <repository-url>
cd ai-stack-demo
./quick-start.sh
```

### Manual Setup
```bash
# 1. Clone and setup
git clone <repository-url>
cd ai-stack-demo

# 2. Copy environment file
cp env.example .env

# 3. Edit configuration (optional)
nano .env

# 4. Start services
docker-compose up -d

# 5. Check status
docker ps
```

## 🔧 Configuration

### Environment Variables

Key configuration options in `.env`:

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

## 📊 Observability & Monitoring

This stack includes comprehensive observability with Grafana and Langfuse:

### 🔍 **Grafana Monitoring (Port 4000)**
- **Infrastructure Metrics**: CPU, memory, disk usage
- **Application Metrics**: N8N workflows, PostgreSQL performance  
- **OpenTelemetry Traces**: Request tracing across services
- **Custom Dashboards**: Pre-configured monitoring views
- **Login**: admin / admin123

### 📈 **Langfuse Analytics (Port 3001)**
- **LLM Conversation Tracking**: All AI interactions logged
- **Cost Analysis**: Track API usage and costs
- **Performance Metrics**: Response times, model performance
- **User Analytics**: Usage patterns and insights
- **A/B Testing**: Compare different AI configurations

### 🔗 **Integrated Observability**
```bash
# 1. Access Grafana
open http://localhost:4000
# Login: admin / admin123

# 2. Access Langfuse  
open http://localhost:3001
# Create account on first visit

# 3. Configure OpenWebUI → Langfuse integration
# Add Langfuse API keys in OpenWebUI settings
# Enable conversation tracking and analytics
```

### 4. Verify Installation
```bash
# Check service status
docker ps

# Test main endpoints
curl http://localhost:3000  # OpenWebUI
curl http://localhost:4000  # Grafana
curl http://localhost:3001  # Langfuse
curl http://localhost:9099  # Pipelines
```

## ⚙️ Configuration

### Environment Variables

#### Domain Configuration
| Variable | Default | Description |
|----------|---------|-------------|
| `WEBUI_DOMAIN` | `localhost` | OpenWebUI domain |
| `WEBUI_PORT` | `8080` | OpenWebUI port |
| `LANGFUSE_DOMAIN` | `http://langfuse:3000` | Langfuse domain |
| `LANGFUSE_PORT` | `3000` | Langfuse port |
| `OLLAMA_PORT` | `11434` | Ollama port |
| `N8N_DOMAIN` | `https://n8n.prayog.io` | N8N domain |

#### Security Configuration
| Variable | Default | Description |
|----------|---------|-------------|
| `LANGFUSE_SECRET_KEY` | `sk-lf-fddf6558-79cc-4950-8015-fb8ec2b59524` | Langfuse secret key |
| `LANGFUSE_PUBLIC_KEY` | `pk-lf-7d3d1bfd-a969-4050-9dfb-119e77bf8c37` | Langfuse public key |
| `NEXTAUTH_SECRET` | `your-secret-key-here-change-this` | NextAuth secret |
| `WEBUI_SECRET_KEY` | `your-secret-key-here-change-this` | OpenWebUI secret key |
| `WEBUI_JWT_SECRET_KEY` | `your-jwt-secret-here-change-this` | JWT secret key |

#### Feature Configuration
| Variable | Default | Description |
|----------|---------|-------------|
| `DEFAULT_MODELS` | `ollama/llama3.1:8b` | Default LLM model |
| `DEFAULT_PROVIDERS` | `ollama` | Default provider |
| `WEBUI_DEFAULT_THEME` | `dark` | UI theme |
| `WEBUI_DEFAULT_LOCALE` | `en` | UI locale |
| `WEBUI_ENABLE_PIPELINES` | `True` | Enable pipelines |
| `WEBUI_ENABLE_WORKFLOWS` | `True` | Enable workflows |
| `WEBUI_ENABLE_TELEMETRY` | `True` | Enable telemetry |
| `WEBUI_LOG_LEVEL` | `INFO` | Log level |

### Configuration Examples

#### Local Development
```bash
# .env file
WEBUI_DOMAIN=localhost
WEBUI_PORT=8080
LANGFUSE_DOMAIN=http://langfuse:3000
LANGFUSE_PORT=3000
OLLAMA_PORT=11434
N8N_DOMAIN=https://marut.gosmile.in
```

#### Production with Custom Domain
```bash
# .env file
WEBUI_DOMAIN=your-app.com
WEBUI_PORT=8080
LANGFUSE_DOMAIN=https://langfuse.your-app.com
LANGFUSE_PORT=3000
OLLAMA_PORT=11434
N8N_DOMAIN=https://n8n.your-app.com
```

## 🔧 Pipeline Integration

### Available Pipelines

#### 1. N8N Pipe (`pipelines/n8n_pipe.py`)
Integrates OpenWebUI with N8N workflows for external processing and automation.

**Features:**
- Connects to N8N webhook endpoints
- Supports bearer token authentication
- Configurable input/output field mapping
- Real-time status updates
- Error handling and logging

**Configuration:**
```json
{
  "n8n_url": "http://localhost:5678/webhook-test/ca7526be-a82b-4c20-b9b6-121ac6e9d8af",
  "n8n_bearer_token": "your-bearer-token",
  "input_field": "chatInput",
  "response_field": "output",
  "emit_interval": 2.0,
  "enable_status_indicator": true
}
```

#### 2. Langfuse Filter (`pipelines/langfuse_filter_pipeline.py`)
Provides Langfuse integration for monitoring, analytics, and tracking.

**Features:**
- Session tracking and analytics
- Model performance monitoring
- Configurable tagging system
- Debug mode for development
- Integration with Langfuse dashboard

**Configuration:**
```json
{
  "langfuse_secret_key": "sk-lf-fddf6558-79cc-4950-8015-fb8ec2b59524",
  "langfuse_public_key": "pk-lf-7d3d1bfd-a969-4050-9dfb-119e77bf8c37",
  "langfuse_host": "http://langfuse:3000/",
  "insert_tags": true,
  "use_model_name_instead_of_id": true,
  "debug": true
}
```

### Pipeline Management

#### Testing Pipelines
```bash
cd pipelines
python3 test_pipelines.py
```

#### Pipeline Configuration
- **Priority**: Set execution order (0 = highest priority)
- **Enabled**: Toggle pipeline on/off
- **Custom Settings**: Configure pipeline-specific parameters

#### Creating New Pipelines
1. Create a new Python file in the `pipelines/` directory
2. Define a `Pipe` or `Filter` class
3. Implement the required methods:
   - `pipe()` for Pipe classes
   - `filter()` for Filter classes
4. Add configuration to `pipeline_config.json`

#### Example Pipeline Structure
```python
class Pipe:
    class Valves(BaseModel):
        # Define your configuration parameters
        pass
    
    def __init__(self):
        self.type = "pipe"
        self.id = "your_pipeline_id"
        self.name = "Your Pipeline Name"
        self.valves = self.Valves()
    
    async def pipe(self, body: dict, **kwargs):
        # Your pipeline logic here
        pass
```

## 🌐 Domain Configuration

### Quick Setup
```bash
./configure-domains.sh
```

### Manual Configuration
```bash
# Create .env file
cp domain-config.env .env
# Edit .env with your settings
```

### Deployment Scenarios

#### 1. Local Development
```bash
./configure-domains.sh
# Choose option 1: Local Development
./start-pipeline-service.sh
```

**Access URLs:**
- OpenWebUI: `http://localhost:8080`
- Langfuse: `http://localhost:3000`
- Ollama: `http://localhost:11434`

#### 2. Production with Custom Domain
```bash
./configure-domains.sh
# Choose option 2: Production
# Enter your domain details
./start-pipeline-service.sh
```

**Access URLs:**
- OpenWebUI: `https://your-app.com:8080`
- Langfuse: `https://langfuse.your-app.com:3000`
- Ollama: `https://your-app.com:11434`

#### 3. Docker Compose with Environment File
```bash
# Create .env file
cp domain-config.env .env
# Edit .env with your settings
docker-compose -f docker-compose-openwebui.yml up -d
```

## 📊 Monitoring

### Langfuse Dashboard
Access the Langfuse dashboard to monitor:
- Pipeline performance
- User interactions
- Model usage statistics
- Error tracking and alerts
- Session analytics

### Service Logs
```bash
# Pipeline service logs
docker logs pipeline-service

# OpenWebUI logs
docker logs openwebui

# Langfuse logs
docker logs langfuse
```

### Health Checks
```bash
# OpenWebUI health
curl http://localhost:8080/health

# Langfuse health
curl http://localhost:3000/api/public/health

# Ollama health
curl http://localhost:11434/api/tags
```

## 🔒 Security Considerations

### 1. Update Default Secrets
Always change the default secret keys:
```bash
# Generate secure secrets
openssl rand -base64 32  # For WEBUI_SECRET_KEY
openssl rand -base64 32  # For WEBUI_JWT_SECRET_KEY
openssl rand -base64 32  # For NEXTAUTH_SECRET
```

### 2. Environment-Specific Configuration
Create different `.env` files for different environments:
```bash
# Development
cp domain-config.env .env.dev

# Production
cp domain-config.env .env.prod

# Staging
cp domain-config.env .env.staging
```

### 3. Docker Secrets (Production)
For production, use Docker secrets:
```yaml
# docker-compose.yml
services:
  openwebui:
    secrets:
      - webui_secret_key
      - langfuse_secret_key

secrets:
  webui_secret_key:
    file: ./secrets/webui_secret_key.txt
  langfuse_secret_key:
    file: ./secrets/langfuse_secret_key.txt
```

## 🛠️ Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Check what's using the port
   lsof -i :8080
   # Change port in .env
   WEBUI_PORT=8081
   ```

2. **Domain Not Resolving**
   ```bash
   # Check DNS resolution
   nslookup your-domain.com
   # Use IP address if needed
   WEBUI_DOMAIN=192.168.1.100
   ```

3. **Docker Network Issues**
   ```bash
   # Recreate network
   docker network prune
   docker-compose down
   docker-compose up -d
   ```

4. **Pipeline not loading**
   ```bash
   # Check file permissions and dependencies
   cd pipelines
   python3 test_pipelines.py
   ```

5. **N8N connection errors**
   ```bash
   # Verify webhook URL and authentication
   curl -X POST https://marut.gosmile.in/n8n/webhook-test/ca7526be-a82b-4c20-b9b6-121ac6e9d8af
   ```

6. **Langfuse integration issues**
   ```bash
   # Confirm API keys and host URL
   curl http://localhost:3000/api/public/health
   ```

### Debug Mode
Enable debug mode in pipeline configuration:
```json
{
  "debug": true
}
```

Enable debug logging:
```bash
# .env file
WEBUI_LOG_LEVEL=DEBUG
LANGFUSE_LOG_LEVEL=DEBUG
```

## 📚 API Reference

### OpenWebUI API
- **Base URL**: `http://localhost:8080`
- **Health Check**: `GET /health`
- **Documentation**: https://docs.openwebui.com/

### Langfuse API
- **Base URL**: `http://localhost:3000`
- **Health Check**: `GET /api/public/health`
- **Documentation**: https://langfuse.com/docs

### Ollama API
- **Base URL**: `http://localhost:11434`
- **Models**: `GET /api/tags`
- **Documentation**: https://ollama.ai/docs

### N8N Webhook
- **Webhook URL**: `http://localhost:5678/webhook-test/ca7526be-a82b-4c20-b9b6-121ac6e9d8af`
- **Method**: `POST`
- **Content-Type**: `application/json`

## 📁 Project Structure

```
operator-stack/
├── docker-compose-openwebui.yml    # Main Docker Compose file
├── openwebui-config.env            # Environment configuration
├── domain-config.env               # Domain configuration template
├── configure-domains.sh            # Domain configuration script
├── start-pipeline-service.sh       # Service startup script
├── start-openwebui.sh             # OpenWebUI startup script
├── README.md                      # This file
├── .gitignore                     # Git ignore file
└── pipelines/                     # Pipeline modules
    ├── __init__.py                # Python package initialization
    ├── requirements.txt           # Python dependencies
    ├── pipeline_config.json      # Pipeline configuration
    ├── n8n_pipe.py              # N8N integration pipeline
    ├── langfuse_filter_pipeline.py # Langfuse monitoring filter
    ├── test_pipelines.py        # Pipeline testing script
    ├── n8n_config_template.json # N8N configuration template
    └── README.md                # Pipeline documentation
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues or questions:
1. Check the logs: `docker-compose logs`
2. Review configuration: `cat .env`
3. Test connectivity: `curl -I http://localhost:8080`
4. Restart services: `docker-compose restart`
5. Check pipeline logs: `docker logs pipeline-service`

## 📚 Additional Resources

- [OpenWebUI Documentation](https://docs.openwebui.com/)
- [Langfuse Documentation](https://langfuse.com/docs)
- [Docker Compose Environment Variables](https://docs.docker.com/compose/environment-variables/)
- [N8N Webhook Documentation](https://docs.n8n.io/integrations/builtin/trigger-nodes/n8n-nodes-base.webhook/)
- [Ollama Documentation](https://ollama.ai/docs)

---

**Status**: ✅ Production Ready  
**Version**: 1.0.0  
**Last Updated**: $(date)  
**Maintainer**: OpenWebUI Team 