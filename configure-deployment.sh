#!/bin/bash

# =================================
# PRAYOG : AI Stack DEMO - Deployment Configuration
# Powered by Prayog.io
# =================================

set -e

echo "🚀 PRAYOG AI Stack - Deployment Configuration"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Function to get current IP address
get_current_ip() {
    # Try multiple methods to get external IP
    IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || curl -s icanhazip.com 2>/dev/null || echo "")
    echo "$IP"
}

# Function to create environment file
create_env_file() {
    local deployment_type="$1"
    local domain_or_ip="$2"
    
    print_step "Creating .env file for $deployment_type deployment..."
    
    # Copy from example
    cp env.example .env
    
    case "$deployment_type" in
        "localhost")
            print_info "Configured for localhost development"
            ;;
        "ec2"|"server")
            # Update webhook URLs for server deployment
            sed -i.bak "s|WEBHOOK_URL=http://localhost:5678/|WEBHOOK_URL=http://${domain_or_ip}:5678/|g" .env
            sed -i.bak "s|WEBHOOK_TUNNEL_URL=http://localhost:5678/|WEBHOOK_TUNNEL_URL=http://${domain_or_ip}:5678/|g" .env
            rm -f .env.bak
            print_info "Configured for server deployment with domain/IP: $domain_or_ip"
            ;;
        "custom")
            # Update webhook URLs for custom domain
            sed -i.bak "s|WEBHOOK_URL=http://localhost:5678/|WEBHOOK_URL=http://${domain_or_ip}:5678/|g" .env
            sed -i.bak "s|WEBHOOK_TUNNEL_URL=http://localhost:5678/|WEBHOOK_TUNNEL_URL=http://${domain_or_ip}:5678/|g" .env
            rm -f .env.bak
            print_info "Configured for custom domain: $domain_or_ip"
            ;;
    esac
    
    print_info "Environment file (.env) created successfully!"
}

echo ""
echo "Choose your deployment type:"
echo "1) 🏠 Local Development (localhost)"
echo "2) 🖥️  EC2/Server (auto-detect IP)"
echo "3) 🖥️  EC2/Server (manual IP/domain)"
echo "4) 🌐 Custom Domain"
echo ""

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        create_env_file "localhost" "localhost"
        echo ""
        print_info "✅ Ready for local development!"
        print_info "Access N8N at: http://localhost:5678"
        ;;
    2)
        print_step "Auto-detecting your current public IP..."
        CURRENT_IP=$(get_current_ip)
        if [ -n "$CURRENT_IP" ]; then
            print_info "Detected IP: $CURRENT_IP"
            create_env_file "ec2" "$CURRENT_IP"
            echo ""
            print_info "✅ Ready for server deployment!"
            print_info "Access N8N at: http://$CURRENT_IP:5678"
            print_warning "Make sure your firewall allows port 5678!"
        else
            print_warning "Could not detect IP automatically. Please use option 3."
            exit 1
        fi
        ;;
    3)
        read -p "Enter your server IP or domain (e.g., 1.2.3.4 or ec2-12-34-56-78.compute-1.amazonaws.com): " server_address
        if [ -n "$server_address" ]; then
            create_env_file "ec2" "$server_address"
            echo ""
            print_info "✅ Ready for server deployment!"
            print_info "Access N8N at: http://$server_address:5678"
            print_warning "Make sure your firewall allows port 5678!"
        else
            print_warning "No server address provided. Exiting."
            exit 1
        fi
        ;;
    4)
        read -p "Enter your custom domain (e.g., myapp.com): " custom_domain
        if [ -n "$custom_domain" ]; then
            create_env_file "custom" "$custom_domain"
            echo ""
            print_info "✅ Ready for custom domain deployment!"
            print_info "Access N8N at: http://$custom_domain:5678"
            print_warning "Make sure DNS points to your server and firewall allows port 5678!"
        else
            print_warning "No domain provided. Exiting."
            exit 1
        fi
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "🔧 Next Steps:"
echo "1. Review your .env file: cat .env"
echo "2. Start the services: ./quick-start.sh"
echo "3. Check status: ./status.sh"
echo ""
echo "📝 Important for Cloud/Server Deployments:"
echo "• Ensure firewall/security groups allow ports: 3000, 3001, 4000, 5678, 6333, 9099"
echo "• For production, update default passwords in .env"
echo "• Consider using HTTPS with a reverse proxy"
echo ""
print_info "Configuration complete! 🎉" 