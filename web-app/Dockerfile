# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json ./

# Копируем файлы yarn если они существуют (используем shell для проверки)
RUN mkdir -p .yarn && \
    (test -f yarn.lock && cp yarn.lock ./ || true) && \
    (test -f .yarnrc.yml && cp .yarnrc.yml ./ || true) && \
    (test -d .yarn && cp -r .yarn ./ || true)

# Установка yarn
RUN if [ -f ".yarnrc.yml" ]; then \
      echo "Using Yarn Berry"; \
      corepack enable && corepack prepare yarn@stable --activate; \
    else \
      echo "Using classic Yarn"; \
      npm install -g yarn; \
    fi

# Install dependencies
RUN if [ -f "yarn.lock" ]; then \
      yarn install --frozen-lockfile; \
    else \
      yarn install; \
    fi

# Copy source code
COPY . .

# Build the application
RUN yarn build

# Production stage
FROM nginx:alpine

# Копируем nginx config если существует
RUN mkdir -p /tmp
COPY nginx.conf /tmp/nginx.conf 2>/dev/null || echo "nginx.conf not found, using default config"
RUN if [ -f "/tmp/nginx.conf" ]; then \
      cp /tmp/nginx.conf /etc/nginx/conf.d/default.conf && \
      echo "Custom nginx config applied"; \
    else \
      echo "Using default nginx config"; \
    fi

# Copy built application from builder
COPY --from=builder /app/build /usr/share/nginx/html

# Копируем entrypoint script если существует
COPY docker-entrypoint.sh /tmp/docker-entrypoint.sh 2>/dev/null || echo "docker-entrypoint.sh not found"
RUN if [ -f "/tmp/docker-entrypoint.sh" ]; then \
      cp /tmp/docker-entrypoint.sh /docker-entrypoint.sh && \
      chmod +x /docker-entrypoint.sh; \
    else \
      echo "#!/bin/sh" > /docker-entrypoint.sh && \
      echo "exec \"\$@\"" >> /docker-entrypoint.sh && \
      chmod +x /docker-entrypoint.sh && \
      echo "Created default entrypoint script"; \
    fi

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]