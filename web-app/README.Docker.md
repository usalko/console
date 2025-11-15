# MinIO Console Web App - Docker Deployment

This directory contains Docker configurations for running the MinIO Console Web App.

## Quick Start

### Production Build

Build and run the production version:

```bash
# Build the Docker image
docker build -t minio-console-web:latest .

# Run with docker-compose (includes MinIO server and backend)
docker-compose up -d

# Or run standalone (requires external MinIO Console backend)
docker run -d \
  --name minio-console-web \
  -p 5005:80 \
  minio-console-web:latest
```

Access the application at: http://localhost:5005

### Development Mode with Hot Reload

For development with hot module replacement:

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up -d

# View logs
docker-compose -f docker-compose.dev.yml logs -f web-app-dev

# Stop
docker-compose -f docker-compose.dev.yml down
```

Access the development server at: http://localhost:5005

## File Structure

```
web-app/
├── Dockerfile              # Production build (multi-stage)
├── Dockerfile.dev          # Development build with hot reload
├── docker-compose.yml      # Production deployment
├── docker-compose.dev.yml  # Development environment
├── nginx.conf             # Nginx configuration for production
└── .dockerignore          # Files to exclude from Docker build
```

## Configuration

### Environment Variables

The web app can be configured using environment variables:

- `NODE_ENV` - Set to `production` or `development`
- `REACT_APP_API_URL` - Backend API URL (default: proxied through nginx)

### Nginx Configuration

The `nginx.conf` file configures:
- Static file serving
- Gzip compression
- Security headers
- API proxy to backend (port 9090)
- Client-side routing support
- Cache settings

### Customizing Backend Connection

To connect to a different MinIO Console backend, update the proxy configuration in `nginx.conf`:

```nginx
location /api/ {
    proxy_pass http://your-backend-host:9090;
    # ... other proxy settings
}
```

Or use environment variables in docker-compose:

```yaml
services:
  minio-console:
    environment:
      - CONSOLE_MINIO_SERVER=http://your-minio-server:9000
```

## Building for Different Architectures

### Multi-platform Build

```bash
# Enable buildx
docker buildx create --use

# Build for multiple platforms
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t minio-console-web:latest \
  --push .
```

## Health Checks

The production container includes health checks:

```bash
# Check container health
docker inspect --format='{{.State.Health.Status}}' minio-console-web

# View health check logs
docker inspect --format='{{range .State.Health.Log}}{{.Output}}{{end}}' minio-console-web
```

## Troubleshooting

### Check Logs

```bash
# Production logs
docker-compose logs -f web-app

# Development logs
docker-compose -f docker-compose.dev.yml logs -f web-app-dev
```

### Container Shell Access

```bash
# Production container
docker exec -it minio-console-web sh

# Development container
docker exec -it minio-console-web-dev sh
```

### Common Issues

1. **Port already in use**: Change the port mapping in docker-compose.yml
   ```yaml
   ports:
     - "8080:80"  # Change 5005 to 8080
   ```

2. **Cannot connect to backend**: Ensure the backend service is running and the proxy configuration is correct

3. **Hot reload not working (dev)**: Make sure `CHOKIDAR_USEPOLLING=true` is set

## Production Deployment

For production deployment, consider:

1. **Use a reverse proxy** (e.g., Traefik, nginx) for SSL/TLS termination
2. **Set resource limits** in docker-compose:
   ```yaml
   deploy:
     resources:
       limits:
         cpus: '1'
         memory: 512M
   ```
3. **Use secrets** for sensitive configuration
4. **Enable monitoring** with health checks and logging
5. **Implement backup strategy** for volumes

## Advanced Usage

### Custom Build with Build Args

```bash
docker build \
  --build-arg NODE_VERSION=18 \
  --build-arg NGINX_VERSION=alpine \
  -t minio-console-web:custom .
```

### Using with Kubernetes

Export docker-compose to Kubernetes manifests:

```bash
# Install kompose
curl -L https://github.com/kubernetes/kompose/releases/download/v1.31.2/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo mv kompose /usr/local/bin/

# Convert
kompose convert -f docker-compose.yml
```

## Localization Support

The web app includes internationalization (i18n) support with:
- English (default)
- Russian (русский)

Language can be switched using the language selector in the UI. The selected language is persisted in browser localStorage.

## Performance Optimization

The production build includes:
- Multi-stage build for smaller image size
- Gzip compression for assets
- Static asset caching
- Minified and optimized JavaScript/CSS
- Tree-shaking of unused code

## Security

The nginx configuration includes:
- Security headers (X-Frame-Options, X-Content-Type-Options, etc.)
- Disabled directory listing
- Request size limits
- Rate limiting (can be configured)

## License

This project is licensed under GNU AGPL v3. See LICENSE file for details.
