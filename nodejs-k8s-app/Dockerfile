# ── Stage 1: Use official lightweight Node 18 Alpine image ──
# Alpine Linux is only ~5MB vs ~900MB for full Ubuntu node image
FROM node:18-alpine

# Set working directory inside container
WORKDIR /app

# Copy package files first (better Docker layer caching)
# If package.json doesn't change, npm install layer is reused
COPY package*.json ./

# Install only production dependencies (no devDependencies)
RUN npm install --omit=dev

# Copy application source code
COPY app.js .

# Expose the port the app runs on
EXPOSE 3000

# Environment variable defaults (overridable by Kubernetes)
ENV PORT=3000
ENV APP_VERSION=1.0.0

# Run as non-root user for security best practice
USER node

# Start the application
CMD ["node", "app.js"]
