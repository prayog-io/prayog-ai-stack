# 🚀 PRAYOG : AI Stack DEMO - Quick Start Guide

Get your complete AI development environment running in **2 commands**!

**Powered by [Prayog.io](https://prayog.io)** - Your Ultimate AI Development Platform

## ⚡ Super Quick Start (One Command)

```bash
./quick-start.sh
```

That's it! This single command will:
- ✅ Check all prerequisites
- ✅ Set up the environment
- ✅ Pull Docker images
- ✅ Start all services
- ✅ Wait for everything to be ready

## 🎯 What You Get

| Service | URL | Description |
|---------|-----|-------------|
| 🤖 **Open WebUI** | http://localhost:3000 | AI Chat Interface |
| 🔄 **N8N** | http://localhost:5678 | Workflow Automation with OpenTelemetry |
| 🗂️ **Qdrant** | http://localhost:6333 | Vector Database |
| 🗄️ **PostgreSQL** | localhost:5433 | Relational Database |

## 📋 Prerequisites

- **Docker** + **Docker Compose** (running)
- **4GB+ RAM** recommended
- **~2GB storage** for images
- **Ports**: 3000, 5678, 6333, 5433 (available)

## 🛠️ Alternative: Step-by-Step

If you prefer to run setup and start separately:

```bash
# 1. Setup environment
./setup.sh

# 2. Start services
./start.sh
```

## 🎮 Management Commands

| Command | Description |
|---------|-------------|
| `./status.sh` | Check service health |
| `./logs.sh` | View service logs |
| `./stop.sh` | Stop all services |
| `./quick-start.sh` | Restart everything |

## 🔍 Advanced Usage

### View logs with options
```bash
./logs.sh -f          # Follow all logs
./logs.sh n8n         # View N8N logs only
./logs.sh -e          # Show errors only
./logs.sh -i          # Interactive log viewer
```

### Check status with monitoring
```bash
./status.sh           # One-time status check
./status.sh --watch   # Continuous monitoring
```

### Stop with cleanup options
```bash
./stop.sh             # Graceful stop
./stop.sh --clean     # Stop + remove volumes
./stop.sh --purge     # Stop + remove everything
```

## 🚨 Troubleshooting

### Port conflicts?
```bash
# Check what's using ports
lsof -i :3000

# Or modify ports in .env file
nano .env
```

### Services not starting?
```bash
# Check Docker
docker info

# View detailed logs
./logs.sh -e

# Force restart
./stop.sh --force
./quick-start.sh
```

### Need to reset everything?
```bash
./stop.sh --purge
./quick-start.sh
```

## 🎉 First Steps After Setup

1. **Open WebUI** (http://localhost:3000)
   - Create an account
   - Start chatting with AI models
   
2. **N8N with OpenTelemetry** (http://localhost:5678)
   - Set up your first workflow or Import From Prayog.io
   - Connect to external APIs
   - Monitor workflow performance with built-in tracing
   - View metrics at http://localhost:5678/metrics
   
3. **Qdrant** (http://localhost:6333)
   - Access vector database dashboard
   - Store and query embeddings

## 📊 OpenTelemetry Observability (N8N)

Your N8N instance comes with built-in OpenTelemetry tracing and monitoring:

### **🔍 Observability Features:**
- **Workflow Tracing**: Track complete workflow execution spans
- **Node-Level Monitoring**: Monitor individual node performance
- **Error Tracking**: Automatic exception recording and status tracking
- **Metrics Export**: Prometheus-compatible metrics endpoint
- **Custom Instrumentation**: Enhanced visibility into execution flow

### **📡 Monitoring Endpoints:**
- **Metrics**: http://localhost:5678/metrics (Prometheus format)
- **Health Check**: http://localhost:5678/healthz
- **Traces**: Exported to `http://insights.delcaper.com:4318` (OTLP)

### **🛠️ Trace Data Includes:**
- Workflow execution duration and status
- Node execution performance and outputs
- Database query performance (PostgreSQL)
- HTTP request/response tracking
- Error details and stack traces

## 💡 Pro Tips

- All data persists between restarts
- Use `./status.sh --watch` to monitor services
- Check `./logs.sh -e` if something goes wrong
- Monitor N8N performance via `/metrics` endpoint
- Customize OpenTelemetry settings in `.env` file

---

**Need help?** Run any script with `--help` for detailed options!

**Having issues?** Check the logs with `./logs.sh -e` 🔍 