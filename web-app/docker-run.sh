#!/bin/bash

# MinIO Console Web App - Docker Run Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
MODE="production"
ACTION="up"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dev)
      MODE="development"
      shift
      ;;
    -s|--stop)
      ACTION="down"
      shift
      ;;
    -r|--restart)
      ACTION="restart"
      shift
      ;;
    -l|--logs)
      ACTION="logs"
      shift
      ;;
    -b|--build)
      ACTION="build"
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  -d, --dev          Run in development mode"
      echo "  -s, --stop         Stop the containers"
      echo "  -r, --restart      Restart the containers"
      echo "  -l, --logs         Show logs"
      echo "  -b, --build        Build and run"
      echo "  -h, --help         Show this help message"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

# Determine docker-compose file
if [ "$MODE" == "development" ]; then
  COMPOSE_FILE="docker-compose.dev.yml"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}  MinIO Console Web App - Development Mode${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
else
  COMPOSE_FILE="docker-compose.yml"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}  MinIO Console Web App - Production Mode${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
fi

echo ""

# Execute action
case $ACTION in
  up)
    echo -e "${YELLOW}Starting containers...${NC}"
    docker-compose -f "$COMPOSE_FILE" up -d
    echo ""
    echo -e "${GREEN}✓ Containers started successfully!${NC}"
    echo ""
    echo -e "${YELLOW}Access the application at:${NC}"
    if [ "$MODE" == "development" ]; then
      echo -e "${BLUE}  Web App (Dev):     http://localhost:5005${NC}"
    else
      echo -e "${BLUE}  Web App:           http://localhost:5005${NC}"
    fi
    echo -e "${BLUE}  MinIO Console:     http://localhost:9090${NC}"
    echo -e "${BLUE}  MinIO Server:      http://localhost:9001${NC}"
    echo ""
    echo -e "${YELLOW}View logs with:${NC} $0 --logs"
    echo -e "${YELLOW}Stop with:${NC} $0 --stop"
    ;;
  down)
    echo -e "${YELLOW}Stopping containers...${NC}"
    docker-compose -f "$COMPOSE_FILE" down
    echo -e "${GREEN}✓ Containers stopped${NC}"
    ;;
  restart)
    echo -e "${YELLOW}Restarting containers...${NC}"
    docker-compose -f "$COMPOSE_FILE" restart
    echo -e "${GREEN}✓ Containers restarted${NC}"
    ;;
  logs)
    echo -e "${YELLOW}Showing logs (Ctrl+C to exit)...${NC}"
    docker-compose -f "$COMPOSE_FILE" logs -f
    ;;
  build)
    echo -e "${YELLOW}Building and starting containers...${NC}"
    docker-compose -f "$COMPOSE_FILE" up -d --build
    echo -e "${GREEN}✓ Build and start completed!${NC}"
    ;;
esac

echo ""
