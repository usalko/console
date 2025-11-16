# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json ./

# Копируем файлы yarn если они существуют в контексте
COPY yarn.lock ./
COPY .yarnrc.yml ./
COPY .yarn/ .yarn/

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

# Копируем nginx config (должен существовать в контексте)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built application from builder
COPY --from=builder /app/build /usr/share/nginx/html

# Копируем entrypoint script (должен существовать в контексте)
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]