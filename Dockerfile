# Frontend Dockerfile
FROM node:18-alpine AS frontend-builder

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm run build

# Production image
FROM node:18-alpine AS frontend

WORKDIR /app

# Copy built assets from builder stage
COPY --from=frontend-builder /app/next.config.mjs ./
COPY --from=frontend-builder /app/public ./public
COPY --from=frontend-builder /app/.next ./.next
COPY --from=frontend-builder /app/node_modules ./node_modules
COPY --from=frontend-builder /app/package.json ./package.json

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Expose the port the app will run on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
