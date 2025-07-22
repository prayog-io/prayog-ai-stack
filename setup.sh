#!/bin/bash

# =================================
# PRAYOG : AI Stack DEMO Setup Script
# =================================

set -e

echo "🚀 Setting up PRAYOG : AI Stack DEMO..."

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

# Check if Docker is installed and running
check_docker() {
    print_status "Checking Docker installation..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker is not running. Please start Docker first."
        exit 1
    fi
    
    print_success "Docker is installed and running"
}

# Check if Docker Compose is available
check_docker_compose() {
    print_status "Checking Docker Compose..."
    
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_error "Docker Compose is not available. Please install Docker Compose."
        exit 1
    fi
    
    print_success "Docker Compose is available"
}

# Create environment file
setup_environment() {
    print_status "Setting up environment configuration..."
    
    if [ ! -f ".env" ]; then
        if [ -f "env.example" ]; then
            cp env.example .env
            print_success "Created .env file from env.example"
        else
            print_error "env.example file not found"
            exit 1
        fi
    else
        print_warning ".env file already exists, skipping..."
    fi
}

# Create Docker volume
create_docker_volume() {
    print_status "Creating Docker volume 'mnt'..."
    
    if docker volume inspect mnt &> /dev/null; then
        print_warning "Docker volume 'mnt' already exists"
    else
        docker volume create mnt
        print_success "Created Docker volume 'mnt'"
    fi
}

# Create necessary directories for mounted volumes
create_directories() {
    print_status "Creating necessary directories..."
    
    # Create directories that might be needed
    directories=(
        "volumes"
        "volumes/app"
        "volumes/db"
        "volumes/redis"
    )
    
    for dir in "${directories[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            print_success "Created directory: $dir"
        fi
    done
}

# Pull Docker images
pull_images() {
    print_status "Pulling Docker images..."
    
    # Use docker-compose to pull images
    if command -v docker-compose &> /dev/null; then
        docker-compose pull
    else
        docker compose pull
    fi
    
    print_success "Docker images pulled successfully"
}

# Main setup function
main() {
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║    PRAYOG : AI Stack DEMO Setup      ║"
    echo "╚══════════════════════════════════════╝"
    echo ""
    
    check_docker
    check_docker_compose
    setup_environment
    create_docker_volume
    create_directories
    pull_images
    
    echo ""
    print_success "Setup completed successfully! 🎉"
    echo ""
    echo "Next steps:"
    echo "1. Review and customize .env file if needed"
    echo "2. Run './start.sh' to start all services"
    echo "3. Run './status.sh' to check service status"
    echo ""
    echo "Services will be available at:"
    echo "  • Open WebUI: http://localhost:3000"
    echo "  • N8N: http://localhost:5678"
    echo "  • Qdrant: http://localhost:6333"
    echo "  • PostgreSQL: localhost:5432"
    echo ""
}

# Run main function
main "$@" 