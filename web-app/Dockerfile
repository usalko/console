# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json ./
# Копируем yarn.lock только если он существует
COPY yarn.loc[k] ./
# Копируем .yarnrc.yml только если существует
COPY .yarnrc.ym[l] ./

# Копируем .yarn только если существует (для Yarn Berry)
COPY .yar[n] .yarn/ 2>/dev/null || true

# Установка yarn если нужно
RUN if [ -f ".yarnrc.yml" ]; then \
      echo "Using Yarn Berry"; \
      corepack enable && corepack prepare yarn@stable --activate; \
    else \
      echo "Using classic Yarn"; \
      npm install -g yarn; \
    fi

# Install dependencies
RUN yarn install --frozen-lockfile || yarn install

# Copy source code
COPY . .

# Build the application
RUN yarn build

# Production stage
FROM nginx:alpine

# Copy custom nginx config if exists
COPY nginx.conf /tmp/nginx.conf 2>/dev/null || true
RUN if [ -f "/tmp/nginx.conf" ]; then \
      cp /tmp/nginx.conf /etc/nginx/conf.d/default.conf; \
      echo "Custom nginx config applied"; \
    else \
      echo "Using default nginx config"; \
    fi

# Copy built application from builder
COPY --from=builder /app/build /usr/share/nginx/html

# Copy entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]