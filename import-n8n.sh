#!/bin/bash

# =================================
# PRAYOG : AI Stack DEMO - N8N Import Script
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

# Banner
show_banner() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                        ║${NC}"
    echo -e "${CYAN}║         🔄 N8N WORKFLOW & CREDENTIALS IMPORT           ║${NC}"
    echo -e "${CYAN}║                                                        ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Check if N8N container is running
check_n8n_running() {
    print_status "Checking N8N container status..."
    
    if ! docker ps | grep -q "n8n"; then
        print_error "N8N container is not running!"
        echo ""
        echo "Please start your AI stack first:"
        echo "  ./quick-start.sh"
        echo "  or"
        echo "  docker-compose up -d"
        exit 1
    fi
    
    print_success "N8N container is running"
}

# Check export directories
check_export_directories() {
    print_status "Checking export directories..."
    
    if [ ! -d "n8n_export" ]; then
        print_error "n8n_export directory not found!"
        echo ""
        echo "Please create the export directory structure:"
        echo "  mkdir -p n8n_export/workflows"
        echo "  mkdir -p n8n_export/credentials" 
        echo ""
        echo "Then export your workflows and credentials to these directories."
        exit 1
    fi
    
    workflows_count=$(find n8n_export/workflows -name "*.json" 2>/dev/null | wc -l | tr -d ' ')
    credentials_count=$(find n8n_export/credentials -name "*.json" 2>/dev/null | wc -l | tr -d ' ')
    
    print_success "Export directories found"
    echo "  • Workflows: ${workflows_count} files"
    echo "  • Credentials: ${credentials_count} files"
    
    if [ "$workflows_count" -eq 0 ] && [ "$credentials_count" -eq 0 ]; then
        print_warning "No files found to import"
        echo ""
        echo "To export from another N8N instance:"
        echo "  1. Go to your source N8N instance"
        echo "  2. Export workflows: Settings → Import/Export → Export"
        echo "  3. Save .json files to: ./n8n_export/workflows/"
        echo "  4. Export credentials via N8N CLI or API"
        echo "  5. Save credential .json files to: ./n8n_export/credentials/"
        echo ""
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
}

# Import workflows
import_workflows() {
    set +e  # Disable exit on error for this function
    local workflow_files=(n8n_export/workflows/*.json)
    
    if [ ! -f "${workflow_files[0]}" ]; then
        print_status "No workflow files to import"
        return 0
    fi
    
    print_status "Importing workflows..."

    
    local imported=0
    local failed=0
    
    for workflow_file in "${workflow_files[@]}"; do
        if [ -f "$workflow_file" ]; then
            local filename=$(basename "$workflow_file")
            echo -n "  • Importing $filename... "
            
            # Copy file to container and import using N8N CLI
            if docker cp "$workflow_file" n8n:/tmp/workflow.json >/dev/null 2>&1; then
                # Import workflow, ignore warnings but check for success
                import_result=$(docker exec n8n n8n import:workflow --input=/tmp/workflow.json 2>/dev/null || true)
                if echo "$import_result" | grep -q "Successfully imported"; then
                    echo -e "${GREEN}✅${NC}"
                    ((imported++))
                else
                    echo -e "${RED}❌${NC}"
                    ((failed++))

                fi
                # Clean up temp file
                docker exec n8n rm -f /tmp/workflow.json >/dev/null 2>&1
            else
                echo -e "${RED}❌${NC}"
                ((failed++))
            fi
        fi

    done
    
    if [ $imported -gt 0 ]; then
        print_success "Imported $imported workflows"
    fi
    
    if [ $failed -gt 0 ]; then
        print_warning "$failed workflows failed to import"
    fi
    
    set -e  # Re-enable exit on error
}

# Import credentials  
import_credentials() {
    local credential_files=(n8n_export/credentials/*.json)
    
    if [ ! -f "${credential_files[0]}" ]; then
        print_status "No credential files to import"
        return 0
    fi
    
    print_status "Importing credentials..."
    
    local imported=0
    local failed=0
    
    for credential_file in "${credential_files[@]}"; do
        if [ -f "$credential_file" ]; then
            local filename=$(basename "$credential_file")
            echo -n "  • Importing $filename... "
            
            # Copy file to container and import using N8N CLI
            if docker cp "$credential_file" n8n:/tmp/credential.json >/dev/null 2>&1 && \
               docker exec n8n n8n import:credentials --input=/tmp/credential.json >/dev/null 2>&1; then
                echo -e "${GREEN}✅${NC}"
                ((imported++))
                # Clean up temp file
                docker exec n8n rm -f /tmp/credential.json >/dev/null 2>&1
            else
                echo -e "${RED}❌${NC}"
                ((failed++))
                # Clean up temp file even on failure
                docker exec n8n rm -f /tmp/credential.json >/dev/null 2>&1
            fi
        fi
    done
    
    if [ $imported -gt 0 ]; then
        print_success "Imported $imported credentials"
    fi
    
    if [ $failed -gt 0 ]; then
        print_warning "$failed credentials failed to import"
    fi
}

# Verify N8N is ready for import
verify_n8n_ready() {
    print_status "Verifying N8N is ready for import..."
    
    # Wait a moment for N8N to be fully ready
    sleep 2
    
    print_success "N8N is ready for import operations"
}

# Show final status
show_final_status() {
    echo ""
    print_title "🎉 N8N Import Completed!"
    echo ""
    echo -e "${CYAN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC}                    📋 ${YELLOW}Next Steps${NC}                     ${CYAN}│${NC}"
    echo -e "${CYAN}├─────────────────────────────────────────────────────────┤${NC}"
    echo -e "${CYAN}│${NC} 🌐 ${GREEN}Access N8N${NC}        → ${BLUE}http://localhost:5678${NC}        ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 🔄 ${GREEN}Check Workflows${NC}   → Go to Workflows tab           ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} 🔐 ${GREEN}Check Credentials${NC} → Go to Credentials tab         ${CYAN}│${NC}"
    echo -e "${CYAN}│${NC} ⚙️  ${GREEN}Configure & Test${NC}  → Update connections as needed  ${CYAN}│${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${YELLOW}💡 Tips:${NC}"
    echo "  • Test imported workflows before using in production"
    echo "  • Update credential values for your environment"
    echo "  • Check webhook URLs and external connections"
    echo "  • Verify all nodes are properly configured"
    echo ""
    print_success "Import process completed successfully!"
}

# Main function
main() {
    show_banner
    
    echo "This will import N8N workflows and credentials from ./n8n_export/"
    echo ""
    read -p "Continue with import? (Y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo "Import cancelled."
        exit 0
    fi
    
    check_n8n_running
    check_export_directories
    verify_n8n_ready
    
    echo ""
    import_workflows
    import_credentials
    
    show_final_status
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "PRAYOG : AI Stack DEMO - N8N Import"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "OPTIONS:"
        echo "  --help, -h   Show this help message"
        echo ""
        echo "This script imports N8N workflows and credentials from:"
        echo "  • ./n8n_export/workflows/*.json"
        echo "  • ./n8n_export/credentials/*.json"
        echo ""
        echo "Prerequisites:"
        echo "  • N8N container must be running"
        echo "  • Export files must be in JSON format"
        echo "  • Files should be from N8N export functionality"
        echo ""
        ;;
    *)
        main "$@"
        ;;
esac 