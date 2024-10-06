# Use a multi-arch base image
FROM --platform=$BUILDPLATFORM node:22-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code
COPY . .

# Create a smaller production image
FROM node:22-alpine

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy only necessary files from builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/src ./src
COPY --from=builder /app/node_modules ./node_modules

# Change ownership of the app files to the non-root user
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD ["node", "src/index.js"]
