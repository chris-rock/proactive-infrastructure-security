# Use an official Node runtime as the parent image
FROM node:20-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy the rest of the application code
COPY . .

# Change ownership of the app files to the non-root user
RUN chown -R appuser:appgroup /usr/src/app

# Switch to the non-root user
USER appuser

# Expose the port the app runs on
EXPOSE 3000

# Run the application
CMD ["node", "src/index.js"]
