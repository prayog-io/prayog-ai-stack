#!/bin/bash

# =================================
# PRAYOG : AI Stack DEMO Status Script
# =================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check service health
check_service_health() {
    local service_name="$1"
    local url="$2"
    local expected_code="${3:-200}"
    
    if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "^${expected_code}$"; then
        echo "✅"
    else
        echo "❌"
    fi
}

# Check container status
check_container_status() {
    local container_name="$1"
    
    if docker ps --filter "name=${container_name}" --filter "status=running" | grep -q "${container_name}"; then
        echo "✅ Running"
    elif docker ps -a --filter "name=${container_name}" | grep -q "${container_name}"; then
        echo "❌ Stopped"
    else
        echo "❌ Not Found"
    fi
}

# Get container resource usage
get_container_stats() {
    local container_name="$1"
    
    if docker ps --filter "name=${container_name}" --filter "status=running" | grep -q "${container_name}"; then
        docker stats --no-stream --format "table {{.CPUPerc}}\t{{.MemUsage}}" "${container_name}" | tail -n 1
    else
        echo "N/A\tN/A"
    fi
}

# Main status check
show_status() {
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║   PRAYOG : AI Stack DEMO Status      ║"
    echo "╚══════════════════════════════════════╝"
    echo ""
    
    # Container Status
    echo "📦 Container Status:"
    echo "┌─────────────────┬─────────────┬──────────────────┐"
    echo "│ Service         │ Status      │ CPU / Memory     │"
    echo "├─────────────────┼─────────────┼──────────────────┤"
    
    services=("open_webui" "grafana_monitoring" "langfuse" "openwebui_pipelines" "n8n" "qdrant" "postgres")
    for service in "${services[@]}"; do
        status=$(check_container_status "$service")
        stats=$(get_container_stats "$service")
        printf "│ %-15s │ %-11s │ %-16s │\n" "$service" "$status" "$stats"
    done
    echo "└─────────────────┴─────────────┴──────────────────┘"
    
    echo ""
    
    # Service Health Check
    echo "🔍 Service Health:"
    echo "┌─────────────────┬─────────────┬──────────────────────────┐"
    echo "│ Service         │ Health      │ URL                      │"
    echo "├─────────────────┼─────────────┼──────────────────────────┤"
    
    # Open WebUI
    health=$(check_service_health "Open WebUI" "http://localhost:3000")
    printf "│ %-15s │ %-11s │ %-24s │\n" "OpenWebUI" "$health" "http://localhost:3000"
    
    # Grafana
    health=$(check_service_health "Grafana" "http://localhost:4000")
    printf "│ %-15s │ %-11s │ %-24s │\n" "Grafana" "$health" "http://localhost:4000"
    
    # Langfuse
    health=$(check_service_health "Langfuse" "http://localhost:3001")
    printf "│ %-15s │ %-11s │ %-24s │\n" "Langfuse" "$health" "http://localhost:3001"
    
    # Pipelines
    health=$(check_service_health "Pipelines" "http://localhost:9099")
    printf "│ %-15s │ %-11s │ %-24s │\n" "Pipelines" "$health" "http://localhost:9099"
    
    # N8N
    health=$(check_service_health "N8N" "http://localhost:5678")
    printf "│ %-15s │ %-11s │ %-24s │\n" "N8N" "$health" "http://localhost:5678"
    
    # Qdrant
    health=$(check_service_health "Qdrant" "http://localhost:6333/health")
    printf "│ %-15s │ %-11s │ %-24s │\n" "Qdrant" "$health" "http://localhost:6333"
    
    # PostgreSQL (check via docker exec)
    if docker exec postgres pg_isready -U admin -d n8n &> /dev/null; then
        pg_health="✅"
    else
        pg_health="❌"
    fi
    printf "│ %-15s │ %-11s │ %-24s │\n" "PostgreSQL" "$pg_health" "localhost:5433"
    
    echo "└─────────────────┴─────────────┴──────────────────────────┘"
    echo ""
    
    # Docker Compose Status
    echo "🐳 Docker Compose Status:"
    if command -v docker-compose &> /dev/null; then
        docker-compose ps
    else
        docker compose ps
    fi
    
    echo ""
    
    # Volume Information
    echo "💾 Volume Information:"
    echo "┌─────────────────┬──────────────────────────────────────┐"
    echo "│ Volume Name     │ Mount Point / Driver                 │"
    echo "├─────────────────┼──────────────────────────────────────┤"
    
    if docker volume inspect mnt &> /dev/null; then
        mount_point=$(docker volume inspect mnt --format '{{.Mountpoint}}')
        printf "│ %-15s │ %-36s │\n" "mnt" "$mount_point"
    else
        printf "│ %-15s │ %-36s │\n" "mnt" "❌ Not Found"
    fi
    
    echo "└─────────────────┴──────────────────────────────────────┘"
    echo ""
    
    # Network Information
    echo "🌐 Network Information:"
    if docker network ls | grep -q "ai-stack-demo_app_network"; then
        print_success "app_network is available"
    else
        print_warning "app_network not found"
    fi
    
    echo ""
    
    # Quick Access Commands
    echo "🚀 Quick Commands:"
    echo "  • View logs:           ./logs.sh"
    echo "  • Restart services:    ./restart.sh"
    echo "  • Stop services:       ./stop.sh"
    echo "  • Update services:     ./update.sh"
    echo ""
}

# Handle script arguments
case "${1:-}" in
    --watch|-w)
        echo "Watching service status (Ctrl+C to exit)..."
        while true; do
            clear
            show_status
            sleep 10
        done
        ;;
    --help|-h)
        echo "Usage: $0 [--watch] [--help]"
        echo ""
        echo "Options:"
        echo "  --watch, -w  Watch service status with auto-refresh"
        echo "  --help, -h   Show this help message"
        echo ""
        ;;
    "")
        show_status
        ;;
    *)
        print_error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac 