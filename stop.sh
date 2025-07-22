#!/bin/bash

# =================================
# PRAYOG : AI Stack DEMO Stop Script
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

# Stop services
stop_services() {
    print_status "Stopping PRAYOG : AI Stack DEMO services..."
    
    # Use docker-compose to stop services
    if command -v docker-compose &> /dev/null; then
        docker-compose down
    else
        docker compose down
    fi
    
    print_success "Services stopped successfully!"
}

# Stop and remove everything including volumes
stop_and_clean() {
    print_status "Stopping and cleaning up AI Stack Demo..."
    
    # Stop and remove containers, networks, and volumes
    if command -v docker-compose &> /dev/null; then
        docker-compose down -v --remove-orphans
    else
        docker compose down -v --remove-orphans
    fi
    
    print_success "Services stopped and cleaned up!"
}

# Stop and remove everything including images
stop_and_purge() {
    print_warning "This will remove all containers, networks, volumes, and images!"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Stopping and purging AI Stack Demo..."
        
        # Stop and remove everything
        if command -v docker-compose &> /dev/null; then
            docker-compose down -v --rmi all --remove-orphans
        else
            docker compose down -v --rmi all --remove-orphans
        fi
        
        # Remove the external volume
        if docker volume inspect mnt &> /dev/null; then
            print_status "Removing external volume 'mnt'..."
            docker volume rm mnt
        fi
        
        print_success "Services stopped and completely purged!"
    else
        print_status "Operation cancelled."
    fi
}

# Force stop containers
force_stop() {
    print_status "Force stopping all containers..."
    
    # Get container names and force stop them
    containers=$(docker ps -a --filter "label=com.docker.compose.project=ai-stack-demo" --format "{{.Names}}")
    
    if [ -n "$containers" ]; then
        echo "$containers" | xargs docker stop -t 5
        echo "$containers" | xargs docker rm -f
        print_success "Containers force stopped and removed!"
    else
        print_warning "No containers found to stop"
    fi
}

# Main function
main() {
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║   Stopping PRAYOG : AI Stack DEMO   ║"
    echo "╚══════════════════════════════════════╝"
    echo ""
    
    stop_services
    
    echo ""
    print_success "🛑 PRAYOG : AI Stack DEMO has been stopped!"
    echo ""
    echo "To start again, run: ./start.sh"
    echo ""
}

# Handle script arguments
case "${1:-}" in
    --clean)
        echo ""
        echo "╔══════════════════════════════════════╗"
        echo "║ Cleaning PRAYOG : AI Stack DEMO     ║"
        echo "╚══════════════════════════════════════╝"
        echo ""
        stop_and_clean
        ;;
    --purge)
        echo ""
        echo "╔══════════════════════════════════════╗"
        echo "║  Purging PRAYOG : AI Stack DEMO     ║"
        echo "╚══════════════════════════════════════╝"
        echo ""
        stop_and_purge
        ;;
    --force)
        echo ""
        echo "╔════════════════════════════════════════╗"
        echo "║ Force Stopping PRAYOG : AI Stack DEMO ║"
        echo "╚════════════════════════════════════════╝"
        echo ""
        force_stop
        ;;
    --help|-h)
        echo "Usage: $0 [--clean] [--purge] [--force] [--help]"
        echo ""
        echo "Options:"
        echo "  (none)       Stop services gracefully"
        echo "  --clean      Stop services and remove volumes"
        echo "  --purge      Stop services and remove everything including images"
        echo "  --force      Force stop and remove containers"
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