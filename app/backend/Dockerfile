# =========================================================
# Stage 1: Build Stage
# =========================================================
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies first (leverage Docker cache layer)
COPY package*.json ./
RUN npm ci

# Copy TypeScript source code and build
COPY tsconfig.json ./
COPY src/ ./src/
RUN npm run build

# Prune devDependencies to keep production layer small
RUN npm prune --production

# =========================================================
# Stage 2: Runtime Stage (Minimal & Secure)
# =========================================================
FROM node:20-alpine AS runner

# Set production environment
ENV NODE_ENV=production
ENV PORT=5000

WORKDIR /app

# Security: Create non-privileged user and group
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Copy built distribution and production dependencies from builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Change ownership to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose backend application port
EXPOSE 5000

# Container healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:5000/health || exit 1

# Start the node server
CMD ["node", "dist/server.js"]
