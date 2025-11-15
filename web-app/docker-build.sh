#!/bin/bash

# MinIO Console Web App - Docker Build Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
IMAGE_NAME="minio-console-web"
IMAGE_TAG="latest"
BUILD_TYPE="production"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dev)
      BUILD_TYPE="development"
      shift
      ;;
    -t|--tag)
      IMAGE_TAG="$2"
      shift 2
      ;;
    -n|--name)
      IMAGE_NAME="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  -d, --dev          Build development image"
      echo "  -t, --tag TAG      Set image tag (default: latest)"
      echo "  -n, --name NAME    Set image name (default: minio-console-web)"
      echo "  -h, --help         Show this help message"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

echo -e "${GREEN}Building MinIO Console Web App${NC}"
echo -e "${YELLOW}Image: ${IMAGE_NAME}:${IMAGE_TAG}${NC}"
echo -e "${YELLOW}Type: ${BUILD_TYPE}${NC}"
echo ""

if [ "$BUILD_TYPE" == "development" ]; then
  echo -e "${YELLOW}Building development image with hot reload...${NC}"
  docker build -f Dockerfile.dev -t "${IMAGE_NAME}:${IMAGE_TAG}-dev" .
  echo -e "${GREEN}✓ Development image built successfully!${NC}"
  echo -e "${YELLOW}Run with: docker-compose -f docker-compose.dev.yml up${NC}"
else
  echo -e "${YELLOW}Building production image...${NC}"
  docker build -f Dockerfile -t "${IMAGE_NAME}:${IMAGE_TAG}" .
  echo -e "${GREEN}✓ Production image built successfully!${NC}"
  echo -e "${YELLOW}Run with: docker-compose up${NC}"
  echo -e "${YELLOW}Or standalone: docker run -p 5005:80 ${IMAGE_NAME}:${IMAGE_TAG}${NC}"
fi

echo ""
echo -e "${GREEN}Build completed!${NC}"

# Display image info
echo ""
echo -e "${YELLOW}Image details:${NC}"
docker images "${IMAGE_NAME}" | head -2
