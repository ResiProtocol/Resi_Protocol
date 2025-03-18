FROM node:22

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

# Expose the port the app runs on
EXPOSE 3000

# Default command
CMD ["npm", "run", "dev"]
