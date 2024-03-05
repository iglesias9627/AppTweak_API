# Use an official Node.js runtime as a base image
FROM node:20.11.1

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

RUN npm install

# Copy the current directory contents into the container at /app
COPY . /app

CMD ["npm", "start"]
