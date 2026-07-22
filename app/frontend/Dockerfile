# =========================================================
# Stage 1: Build / Prepare Assets Stage
# =========================================================
FROM alpine:3.19 AS builder
WORKDIR /app
COPY src/ ./src/

# =========================================================
# Stage 2: Runtime Stage (Minimal Nginx Alpine)
# =========================================================
FROM nginx:1.25-alpine

# Copy custom Nginx security & proxy configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy static frontend web assets from builder
COPY --from=builder /app/src /usr/share/nginx/html

# Adjust permissions for non-root / nginx user
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

# Expose HTTP port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# Run Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
