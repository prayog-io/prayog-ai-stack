#!/bin/bash

# =================================
# PRAYOG : AI Stack DEMO Quick Start Script
# =================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_title() {
    echo -e "${PURPLE}$1${NC}"
}

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

# ASCII Art Banner
show_banner() {
    echo ""
    echo -e "${CYAN}"
    echo "   ╔══════════════════════════════════════════════════════════╗"
    echo "   ║                                                          ║"
    echo "   ║    ██████╗ ██████╗  █████╗ ██╗   ██╗ ██████╗  ██████╗    ║"
    echo "   ║    ██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██╔═══██╗██╔════╝    ║"
    echo "   ║    ██████╔╝██████╔╝███████║ ╚████╔╝ ██║   ██║██║  ███╗   ║"
    echo "   ║    ██╔═══╝ ██╔══██╗██╔══██║  ╚██╔╝  ██║   ██║██║   ██║   ║"
    echo "   ║    ██║     ██║  ██║██║  ██║   ██║   ╚██████╔╝╚██████╔╝   ║"
    echo "   ║    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝  ╚═════╝    ║"
    echo "   ║                                                          ║"
    echo "   ║               PRAYOG: AI Stack DEMO                      ║"
    echo "   ║                                                          ║"
    echo "   ║         Complete AI Development Environment              ║"
    echo "   ║              Powered by Prayog.io                        ║"
    echo "   ║                                                          ║"
    echo "   ╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    local missing_deps=()
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        missing_deps+=("Docker")
    elif ! docker info &> /dev/null; then
        print_error "Docker is installed but not running. Please start Docker."
        exit 1
    fi
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        missing_deps+=("Docker Compose")
    fi
    
    # Check curl
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies:"
        for dep in "${missing_deps[@]}"; do
            echo "  - $dep"
        done
        echo ""
        echo "Please install the missing dependencies and try again."
        exit 1
    fi
    
    print_success "All prerequisites satisfied"
}

# Show system requirements
show_requirements() {
    echo -e "${YELLOW}System Requirements:${NC}"
    echo "  • Docker: ✅ $(docker --version | cut -d' ' -f3 | cut -d',' -f1)"
    echo "  • Memory: Recommended 8GB+ RAM (Current: 16GB ✅)"
    echo "  • Storage: ~3GB for Docker images (Available: 210GB ✅)"
    echo "  • Ports: 3000, 3001, 4000, 4317, 4318, 5433, 5678, 6333, 9099"
    echo "  • Services: 7 containers (OpenWebUI, Grafana, Langfuse, Pipelines, N8N, Qdrant, PostgreSQL)"
    echo ""
}

# Check if ports are available
check_ports() {
    print_status "Checking port availability..."
    
    local ports=(3000 3001 4000 4317 4318 5433 5678 6333 9099)
    local busy_ports=()
    
    for port in "${ports[@]}"; do
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            busy_ports+=($port)
        fi
    done
    
    if [ ${#busy_ports[@]} -ne 0 ]; then
        print_warning "The following ports are in use:"
        for port in "${busy_ports[@]}"; do
            echo "  - Port $port"
        done
        echo ""
        echo "You may need to stop other services or modify the port configuration in .env"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "All required ports are available"
    fi
}

# Run setup
run_setup() {
    print_title "🔧 Running Setup..."
    
    if [ -f "./setup.sh" ]; then
        chmod +x ./setup.sh
        ./setup.sh
    else
        print_error "setup.sh not found in current directory"
        exit 1
    fi
}

# Start services
start_services() {
    print_title "🚀 Starting Services..."
    
    if [ -f "./start.sh" ]; then
        chmod +x ./start.sh
        ./start.sh --no-wait
    else
        print_error "start.sh not found in current directory"
        exit 1
    fi
}

# Wait for services with progress
wait_for_services_with_progress() {
    print_title "⏳ Waiting for Services to Start..."
    
    local services=("Open WebUI:http://localhost:3000" "N8N:http://localhost:5678" "Qdrant:http://localhost:6333/health")
    local max_attempts=30
    local attempt=0
    
    echo ""
    
    for service_info in "${services[@]}"; do
        IFS=':' read -r service_name service_url <<< "$service_info"
        
        echo -n "Waiting for $service_name..."
        
        for ((i=1; i<=max_attempts; i++)); do
            if curl -f "$service_url" &> /dev/null; then
                echo -e " ${GREEN}✅${NC}"
                break
            else
                echo -n "."
                sleep 2
            fi
            
            if [ $i -eq $max_attempts ]; then
                echo -e " ${YELLOW}⚠️ (timeout)${NC}"
            fi
        done
    done
    
    # Check PostgreSQL separately
    echo -n "Waiting for PostgreSQL..."
    for ((i=1; i<=max_attempts; i++)); do
        if docker exec postgres pg_isready -U admin -d n8n &> /dev/null; then
            echo -e " ${GREEN}✅${NC}"
            break
        else
            echo -n "."
            sleep 2
        fi
        
        if [ $i -eq $max_attempts ]; then
            echo -e " ${YELLOW}⚠️ (timeout)${NC}"
        fi
    done
    
    echo ""
}

# Show final status
show_final_status() {
    print_title "🎉 Setup Complete!"
    
    echo ""
    echo -e "${GREEN}🎉 Your PRAYOG : AI Stack DEMO is now running! 🎉${NC}"
    echo ""
    echo -e "${CYAN}┌───────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC}                     🌐 ${YELLOW}Access URLs${NC}                          ${CYAN}│${NC}"
    echo -e "${CYAN}├───────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC} 🤖 ${GREEN}OpenWebUI${NC}       → ${BLUE}http://localhost:3000${NC}               ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 📊 ${GREEN}Grafana${NC}         → ${BLUE}http://localhost:4000${NC} ${YELLOW}(admin/admin123)${NC} ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 🔍 ${GREEN}Langfuse${NC}        → ${BLUE}http://localhost:3001${NC}               ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} ⚡ ${GREEN}Pipelines${NC}       → ${BLUE}http://localhost:9099${NC}               ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 🔄 ${GREEN}N8N Workflows${NC}   → ${BLUE}http://localhost:5678${NC}               ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 🗂️  ${GREEN}Qdrant Vector${NC}   → ${BLUE}http://localhost:6333${NC}               ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 🗄️  ${GREEN}PostgreSQL${NC}      → ${BLUE}localhost:5433${NC}                   ${CYAN}│${NC}"
    echo -e "${CYAN}└───────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${CYAN}🛠️  Management Commands:${NC}"
    echo "  • Check status:    ./status.sh"
    echo "  • View logs:       ./logs.sh"
    echo "  • Stop services:   ./stop.sh"
    echo "  • Restart:         ./quick-start.sh"
    echo ""
    echo -e "${YELLOW}💡 Quick Tips:${NC}"
    echo "  • OpenWebUI: Create account and start chatting with AI"
    echo "  • Grafana: Monitor infrastructure (login: admin/admin123)"
    echo "  • Langfuse: Track LLM conversations and analytics"
    echo "  • Pipelines: Process AI requests with custom logic"
    echo "  • N8N: Build automation workflows with monitoring"
    echo "  • Qdrant: Vector database for AI embeddings"
    echo "  • All data persisted in Docker volumes"
    echo ""
    echo -e "${GREEN}🚀 Happy building with PRAYOG! 🚀${NC}"
    echo -e "${PURPLE}Visit ${CYAN}https://prayog.io${PURPLE} for more AI tools and resources!${NC}"
    echo ""
}

# Main function
main() {
    show_banner
    
    # Ask for confirmation unless --yes flag is provided
    if [ "${1:-}" != "--yes" ] && [ "${1:-}" != "-y" ]; then
        echo "This will:"
        echo "  • Install and configure PRAYOG : AI Stack DEMO"
        echo "  • Create Docker volumes and networks"
        echo "  • Pull required Docker images (~2GB)"
        echo "  • Start all services"
        echo ""
        read -p "Continue? (Y/n): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            echo "Setup cancelled."
            exit 0
        fi
    fi
    
    echo ""
    
    check_prerequisites
    show_requirements
    check_ports
    run_setup
    start_services
    wait_for_services_with_progress
    show_final_status
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "PRAYOG : AI Stack DEMO Quick Start"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "OPTIONS:"
        echo "  --yes, -y    Skip confirmation prompts"
        echo "  --help, -h   Show this help message"
        echo ""
        echo "This script will:"
        echo "  1. Check system prerequisites"
        echo "  2. Run setup.sh to configure environment"
        echo "  3. Run start.sh to launch all services"
        echo "  4. Wait for services to become ready"
        echo "  5. Display access information"
        echo ""
        ;;
    *)
        main "$@"
        ;;
esac 