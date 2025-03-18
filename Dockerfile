FROM node:22 AS base

# Install the required packages
RUN apt-get update && apt-get install -y \
    g++ \
    git \
    make \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Default build - for development and basic testing
FROM base AS dev
# Expose the port
EXPOSE 3000
# Start the application
CMD ["npm", "run", "dev"]

# Security tools build - for security testing
FROM base AS security
# Install security tools
RUN apt-get update && apt-get install -y python3-pip && \
    pip3 install slither-analyzer mythril && \
    rm -rf /var/lib/apt/lists/*

