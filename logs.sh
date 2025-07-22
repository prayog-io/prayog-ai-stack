#!/bin/bash

# =================================
# PRAYOG : AI Stack DEMO Logs Script
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

# Show logs for all services
show_all_logs() {
    local follow_flag="$1"
    
    print_status "Showing logs for all services..."
    
    if command -v docker-compose &> /dev/null; then
        if [ "$follow_flag" = "--follow" ]; then
            docker-compose logs -f
        else
            docker-compose logs --tail=100
        fi
    else
        if [ "$follow_flag" = "--follow" ]; then
            docker compose logs -f
        else
            docker compose logs --tail=100
        fi
    fi
}

# Show logs for specific service
show_service_logs() {
    local service="$1"
    local follow_flag="$2"
    
    print_status "Showing logs for service: $service"
    
    if command -v docker-compose &> /dev/null; then
        if [ "$follow_flag" = "--follow" ]; then
            docker-compose logs -f "$service"
        else
            docker-compose logs --tail=100 "$service"
        fi
    else
        if [ "$follow_flag" = "--follow" ]; then
            docker compose logs -f "$service"
        else
            docker compose logs --tail=100 "$service"
        fi
    fi
}

# Show logs with timestamps
show_logs_with_timestamps() {
    local service="$1"
    local follow_flag="$2"
    
    if [ -n "$service" ]; then
        print_status "Showing logs with timestamps for service: $service"
        
        if command -v docker-compose &> /dev/null; then
            if [ "$follow_flag" = "--follow" ]; then
                docker-compose logs -f -t "$service"
            else
                docker-compose logs --tail=100 -t "$service"
            fi
        else
            if [ "$follow_flag" = "--follow" ]; then
                docker compose logs -f -t "$service"
            else
                docker compose logs --tail=100 -t "$service"
            fi
        fi
    else
        print_status "Showing logs with timestamps for all services..."
        
        if command -v docker-compose &> /dev/null; then
            if [ "$follow_flag" = "--follow" ]; then
                docker-compose logs -f -t
            else
                docker-compose logs --tail=100 -t
            fi
        else
            if [ "$follow_flag" = "--follow" ]; then
                docker compose logs -f -t
            else
                docker compose logs --tail=100 -t
            fi
        fi
    fi
}

# Interactive log viewer
interactive_logs() {
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║ PRAYOG Interactive Log Viewer        ║"
    echo "╚══════════════════════════════════════╝"
    echo ""
    echo "Available services:"
    echo "  1) Open WebUI (master_ai_operator)"
    echo "  2) PostgreSQL (postgres)"
    echo "  3) N8N (n8n)"
    echo "  4) Qdrant (qdrant)"
    echo "  5) All services"
    echo ""
    
    read -p "Select service (1-5): " choice
    read -p "Follow logs? (y/N): " follow_choice
    
    follow_flag=""
    if [[ $follow_choice =~ ^[Yy]$ ]]; then
        follow_flag="--follow"
    fi
    
    case $choice in
        1)
            show_service_logs "master_ai_operator" "$follow_flag"
            ;;
        2)
            show_service_logs "postgres" "$follow_flag"
            ;;
        3)
            show_service_logs "n8n" "$follow_flag"
            ;;
        4)
            show_service_logs "qdrant" "$follow_flag"
            ;;
        5)
            show_all_logs "$follow_flag"
            ;;
        *)
            print_error "Invalid choice: $choice"
            exit 1
            ;;
    esac
}

# Show error logs only
show_error_logs() {
    print_status "Showing error logs for all services..."
    
    if command -v docker-compose &> /dev/null; then
        docker-compose logs --tail=100 | grep -i -E "(error|exception|fail|fatal|warn)"
    else
        docker compose logs --tail=100 | grep -i -E "(error|exception|fail|fatal|warn)"
    fi
}

# Export logs to file
export_logs() {
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local log_file="prayog_ai_stack_logs_${timestamp}.txt"
    
    print_status "Exporting logs to: $log_file"
    
    {
        echo "PRAYOG : AI Stack DEMO Logs Export"
        echo "========================="
        echo "Timestamp: $(date)"
        echo "========================="
        echo ""
        
        if command -v docker-compose &> /dev/null; then
            docker-compose logs --tail=1000
        else
            docker compose logs --tail=1000
        fi
    } > "$log_file"
    
    print_success "Logs exported to: $log_file"
}

# Show help
show_help() {
    echo "Usage: $0 [OPTIONS] [SERVICE]"
    echo ""
    echo "OPTIONS:"
    echo "  -f, --follow         Follow log output"
    echo "  -t, --timestamps     Show timestamps"
    echo "  -e, --errors         Show only error/warning logs"
    echo "  -i, --interactive    Interactive log viewer"
    echo "  -x, --export         Export logs to file"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "SERVICES:"
    echo "  master_ai_operator   Open WebUI service"
    echo "  postgres            PostgreSQL database"
    echo "  n8n                 N8N workflow automation"
    echo "  qdrant              Qdrant vector database"
    echo ""
    echo "EXAMPLES:"
    echo "  $0                           # Show recent logs for all services"
    echo "  $0 -f                        # Follow logs for all services"
    echo "  $0 postgres                  # Show logs for PostgreSQL"
    echo "  $0 -f n8n                    # Follow logs for N8N"
    echo "  $0 -t -f master_ai_operator  # Follow Open WebUI logs with timestamps"
    echo "  $0 -e                        # Show only errors and warnings"
    echo "  $0 -i                        # Interactive log viewer"
    echo "  $0 -x                        # Export logs to file"
    echo ""
}

# Parse arguments
FOLLOW=false
TIMESTAMPS=false
ERRORS=false
INTERACTIVE=false
EXPORT=false
SERVICE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--follow)
            FOLLOW=true
            shift
            ;;
        -t|--timestamps)
            TIMESTAMPS=true
            shift
            ;;
        -e|--errors)
            ERRORS=true
            shift
            ;;
        -i|--interactive)
            INTERACTIVE=true
            shift
            ;;
        -x|--export)
            EXPORT=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        master_ai_operator|postgres|n8n|qdrant)
            SERVICE="$1"
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Main execution
if [ "$INTERACTIVE" = true ]; then
    interactive_logs
elif [ "$EXPORT" = true ]; then
    export_logs
elif [ "$ERRORS" = true ]; then
    show_error_logs
else
    follow_flag=""
    if [ "$FOLLOW" = true ]; then
        follow_flag="--follow"
    fi
    
    if [ "$TIMESTAMPS" = true ]; then
        show_logs_with_timestamps "$SERVICE" "$follow_flag"
    elif [ -n "$SERVICE" ]; then
        show_service_logs "$SERVICE" "$follow_flag"
    else
        show_all_logs "$follow_flag"
    fi
fi 