#!/bin/bash

# VictoriaMetrics Stack Management Script
# This script helps manage the VictoriaMetrics monitoring stack

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if docker-compose is installed
check_dependencies() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_error "docker-compose is not installed. Please install docker-compose first."
        exit 1
    fi
}

# Start all services
start_services() {
    print_info "Starting VictoriaMetrics stack..."
    docker-compose up -d
    print_info "Services started successfully!"
    print_info "VictoriaMetrics: http://localhost:8428"
    print_info "VictoriaLogs: http://localhost:9428"
    print_info "VictoriaTraces: http://localhost:10428"
}

# Stop all services
stop_services() {
    print_info "Stopping VictoriaMetrics stack..."
    docker-compose down
    print_info "Services stopped successfully!"
}

# Restart all services
restart_services() {
    print_info "Restarting VictoriaMetrics stack..."
    docker-compose restart
    print_info "Services restarted successfully!"
}

# Show service status
show_status() {
    print_info "Service status:"
    docker-compose ps
}

# Show logs
show_logs() {
    if [ -z "$1" ]; then
        docker-compose logs -f
    else
        docker-compose logs -f "$1"
    fi
}

# Clean up (remove containers and volumes)
cleanup() {
    print_warning "This will remove all containers and data volumes!"
    read -p "Are you sure? (yes/no): " confirm
    if [ "$confirm" = "yes" ]; then
        print_info "Cleaning up..."
        docker-compose down -v
        print_info "Cleanup completed!"
    else
        print_info "Cleanup cancelled."
    fi
}

# Show help
show_help() {
    cat << EOF
VictoriaMetrics Stack Management Script

Usage: $0 [command] [options]

Commands:
    start       Start all services
    stop        Stop all services
    restart     Restart all services
    status      Show service status
    logs [svc]  Show logs (optionally for a specific service)
    cleanup     Remove all containers and volumes
    help        Show this help message

Services:
    victoriametrics   Time-series database
    victorialogs      Log management system
    victoriatraces    Distributed tracing system
    app               Rust application

Examples:
    $0 start                    # Start all services
    $0 logs victoriametrics     # Show VictoriaMetrics logs
    $0 stop                     # Stop all services

EOF
}

# Main script logic
check_dependencies

case "$1" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs "$2"
        ;;
    cleanup)
        cleanup
        ;;
    help|--help|-h|"")
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
