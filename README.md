# AppTweak REST API with NodeJS Data Fetching Module

Welcome to the AppTweak REST API project, accompanied by a NodeJS module designed to fetch and save data daily. This project utilizes Ruby with Sinatra for the REST API and MongoDB for data storage.

## Overview

This project consists of two main components:

1. **REST API (Ruby, Sinatra, MongoDB)**
   - The REST API built using Sinatra and MongoDB provides endpoints for creating/storing locations and
   .

2. **NodeJS Module for Daily Data Fetching**
   - A NodeJS module is incorporated to fetch data daily and store it in MongoDB.

## Features

- **REST API Endpoints:**
  - Two API endpoints for creating and storing locations in MongoDB.
  - Example body format: `{"latitude": 18.50012, "longitude": -70.98857, "slug": "santo-domingo"}`

- **NodeJS Data Fetching Module:**
  - Fetches data daily and ensures it is saved in the MongoDB to be used by the API later.

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/iglesias9626/AppTweak_API.git

## Deploy using Docker

This application was executed using Docker version 4.21.1.

To deploy the application using Docker, follow these steps:

1. Navigate to the directory where the `docker-compose.yml` file is located.

    ```bash
    cd APPTWEAK_API/docker
    ```

2. Run the following command in the terminal to start the Docker containers in the background.

    ```bash
    docker-compose up -d
    ```

This command will initiate the deployment process and run the Docker containers detached from the terminal.

Two directories will be created in your machine: 

```bash
/docker/DB
and
/logs
```

## API Endpoints

### Create a New Location

- **Endpoint:**
POST /locations/
- **Description:**
Create a new location and store it in MongoDB.

- **Request Body:**
    ```json
    {
    "latitude": 18.50012,
    "longitude": -70.98857,
    "slug": "santo-domingo"
    }

### Retrieve temperature forecasts

- **Endpoint:**
GET /temperature_forecast
- **Description:**
Retrieve temperature forecasts of a stored Location in MongoDB.

- **Response example:**
    ```json
    {
    "response": [
        {
            "date": "2024-03-05",
            "min-forecasted": 28,
            "max-forecasted": 30
        },
        {
            "date": "2024-03-06",
            "min-forecasted": 22,
            "max-forecasted": 30
        }
    ]
    }

## Accessing the Services

- **Ruby API (REST API):**
  - Port: 4567 
  - Base URL: http://localhost:4567
  - Endpoint for Locations: /locations
  - Endpoint for Temperature forecasts: /temperature_forecast

- **NodeJS Data Fetching Module:**
  - No specific port

- **MongoDB:**
  - Port: 27017

- **Mongo-Express:**
  - Port: 8081
  - Base URL: http://localhost:8081/

## Environment Variables

## Ruby

## NodeJS
