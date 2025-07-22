#!/bin/bash

# =================================
# PRAYOG : AI Stack DEMO Installer
# =================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo ""
echo -e "${CYAN}"
echo "╔════════════════════════════════════════╗"
echo "║    PRAYOG : AI Stack DEMO Installer   ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

print_status "Making all scripts executable..."
chmod +x *.sh

print_success "Scripts are now executable!"

echo ""
print_status "Ready to start! You can now use:"
echo ""
echo "  🚀 Quick Start (Recommended):"
echo "     ./quick-start.sh"
echo ""
echo "  🔧 Step by Step:"
echo "     ./setup.sh"
echo "     ./start.sh"
echo ""
echo "  📊 Check Status:"
echo "     ./status.sh"
echo ""
echo "  📋 View Logs:"
echo "     ./logs.sh"
echo ""
echo "  🛑 Stop Services:"
echo "     ./stop.sh"
echo ""

read -p "Would you like to run the quick start now? (Y/n): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    print_status "Running quick start..."
    ./quick-start.sh
else
    print_success "Setup complete! Run './quick-start.sh' when ready."
fi 