#!/bin/bash

# =================================
# PRAYOG : AI Stack DEMO Start Script
# =================================

set -e

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

# Check if setup has been run
check_setup() {
    if [ ! -f ".env" ]; then
        print_error "Environment file not found. Please run './setup.sh' first."
        exit 1
    fi
    
    if ! docker volume inspect mnt &> /dev/null; then
        print_error "Docker volume 'mnt' not found. Please run './setup.sh' first."
        exit 1
    fi
}

# Start services
start_services() {
    print_status "Starting PRAYOG : AI Stack DEMO services..."
    
    # Use docker-compose to start services
    if command -v docker-compose &> /dev/null; then
        docker-compose up -d
    else
        docker compose up -d
    fi
    
    print_success "Services started successfully!"
}

# Wait for services to be ready
wait_for_services() {
    print_status "Waiting for services to be ready..."
    
    # Wait for PostgreSQL
    print_status "Waiting for PostgreSQL..."
    timeout=60
    count=0
    while [ $count -lt $timeout ]; do
        if docker exec postgres pg_isready -U admin -d n8n &> /dev/null; then
            print_success "PostgreSQL is ready"
            break
        fi
        sleep 2
        count=$((count + 2))
    done
    
    if [ $count -ge $timeout ]; then
        print_warning "PostgreSQL took longer than expected to start"
    fi
    
    # Wait for Open WebUI
    print_status "Waiting for Open WebUI..."
    timeout=60
    count=0
    while [ $count -lt $timeout ]; do
        if curl -f http://localhost:3000 &> /dev/null; then
            print_success "Open WebUI is ready"
            break
        fi
        sleep 2
        count=$((count + 2))
    done
    
    if [ $count -ge $timeout ]; then
        print_warning "Open WebUI took longer than expected to start"
    fi
    
    # Wait for N8N
    print_status "Waiting for N8N..."
    timeout=60
    count=0
    while [ $count -lt $timeout ]; do
        if curl -f http://localhost:5678 &> /dev/null; then
            print_success "N8N is ready"
            break
        fi
        sleep 2
        count=$((count + 2))
    done
    
    if [ $count -ge $timeout ]; then
        print_warning "N8N took longer than expected to start"
    fi
    
    # Wait for Qdrant
    print_status "Waiting for Qdrant..."
    timeout=60
    count=0
    while [ $count -lt $timeout ]; do
        if curl -f http://localhost:6333/health &> /dev/null; then
            print_success "Qdrant is ready"
            break
        fi
        sleep 2
        count=$((count + 2))
    done
    
    if [ $count -ge $timeout ]; then
        print_warning "Qdrant took longer than expected to start"
    fi
}

# Show service status
show_status() {
    echo ""
    print_status "Service Status:"
    
    if command -v docker-compose &> /dev/null; then
        docker-compose ps
    else
        docker compose ps
    fi
}

# Show access URLs
show_urls() {
    echo ""
    print_success "🎉 PRAYOG : AI Stack DEMO is now running!"
    echo ""
    echo -e "${YELLOW}Access your services:${NC}"
    echo -e "${CYAN}┌─────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} 🌐 ${GREEN}Open WebUI${NC}:  ${BLUE}http://localhost:3000${NC}   ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 🔄 ${GREEN}N8N${NC}:         ${BLUE}http://localhost:5678${NC}   ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 🗂️  ${GREEN}Qdrant${NC}:      ${BLUE}http://localhost:6333${NC}   ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 🗄️  ${GREEN}PostgreSQL${NC}: ${BLUE}localhost:5433${NC}          ${CYAN}│${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────┘${NC}"
    echo ""
    echo "Useful commands:"
    echo "  • View logs:    ./logs.sh"
    echo "  • Check status: ./status.sh"
    echo "  • Stop all:     ./stop.sh"
    echo ""
}

# Main function
main() {
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║  Starting PRAYOG : AI Stack DEMO    ║"
    echo "╚══════════════════════════════════════╝"
    echo ""
    
    check_setup
    start_services
    wait_for_services
    show_status
    show_urls
}

# Handle script arguments
case "${1:-}" in
    --no-wait)
        echo "Starting services without waiting for readiness..."
        check_setup
        start_services
        show_status
        show_urls
        ;;
    --help|-h)
        echo "Usage: $0 [--no-wait] [--help]"
        echo ""
        echo "Options:"
        echo "  --no-wait    Start services without waiting for readiness checks"
        echo "  --help, -h   Show this help message"
        echo ""
        ;;
    "")
        main
        ;;
    *)
        print_error "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac 