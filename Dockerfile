# 6million.istoria.app — static Vite/React page served by nginx on fly.io.

# Build stage: same Node major/minor the Ploi server built with (26.13.1).
FROM node:26.13.1-bookworm-slim AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY . .
RUN npm run build

# Runtime stage: only the built files + nginx.
FROM nginx:1.30.8-alpine
COPY .fly/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8080
