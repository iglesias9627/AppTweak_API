# AppTweak REST API with NodeJS Data Fetching Module

Welcome to the AppTweak REST API project, accompanied by a NodeJS module designed to fetch and save data daily. This project utilizes Ruby with Sinatra for the REST API and MongoDB for data storage.


## Overview

This project consists of two main modules:

1. **REST API (Ruby, Sinatra, MongoDB)**
   - The REST API built using Sinatra and MongoDB provides endpoints for creating/storing locations and
   for retrieving temperature forecasts of stored locations.

   - Whenever a user requests a temperature forecast range for a specific location stored in the database, the application follows a systematic process. Initially, it checks if the requested data already exists in the database. If present, the data is directly retrieved from the database. In case the data is not found, the application proceeds to validate against specific constraints before querying a Weather API (7 Timer-ASTRO).
   
   - When contacting the Weather API, the application fetches all available data. Subsequently, it populates the database with this newly retrieved information, ensuring it is readily available for future user requests. 
   
   - Finally, the application fulfills the user's initial request by providing the list of temperature forecasts for the specified range. This approach helps optimize by minimizing the need to repeatedly query the Weather API. 

2. **NodeJS Module for Daily Data Fetching**
   - A NodeJS module designed for daily data retrieval and storage in MongoDB. Operated by a cron job, the module iterates through the locations stored in the database. For each location, the application retrieves temperature forecasts, calculates the minimum and maximum temperatures for each date in the dataset, and subsequently updates or inserts this data into the database.
   
   - Users have the flexibility to specify the preferred execution time for the module daily. This customization empowers users to control when the system fetches data from the API, ensuring consistent updates and the accumulation of additional data for future days.

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
APPTWEAK_API/docker/DB
APPTWEAK_API/docker/logs
```

`APPTWEAK_API/docker/DB` will store the data from MongoDB to persist data and `APPTWEAK_API/docker/logs` will store the logs of the NodeJS daily-fetching data application.

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
    ```

- **Response example:**
    ```json
    {
        "message": "Location created successfully",
        "location": 
        {
            "_id": 
            {
                "$oid": "65e76728c69d59000104068e"
            },
            "created_at": "2024-03-05T18:40:40.703+00:00",
            "latitude": 18.50012,
            "longitude": -70.98857,
            "slug": "santo-domingo",
            "updated_at": "2024-03-05T18:40:40.703+00:00"
        }
    }
    ```

- **Error when slug already exists:**
    ```json
    {
        "errors": [
            "Slug has already been taken"
        ]
    }
    ```

- **Error when slug format is not correct:**
    ```json
    {
        "errors": [
            "Slug is invalid"
        ]
    }
    ```

### Retrieve temperature forecasts

- **Endpoint:**
GET /temperature_forecast/:slug/:start_date/:end_date
- **Description:**
Retrieve temperature forecasts of a stored Location in MongoDB in a date range. This retrieves the data from database if exists or fetch data from Weather API if the request complies with the constraints.

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
    ```

- **Error when a location does not exists:**
    ```json
    {
        "error": "Location: san-salvador not found in database!"
    }
    ```

- **Error when temperature data does not exists in DB and we cannot retreive it from Weather API:**
    ```json
    {
        "error": "Start date must be from 2024-03-05"
    }
    ```

- **Error when end date is after start date:**
    ```json
    {
        "error": "End date must be after the start date"
    }
    ```

- **Error when date format is not correct:**
    ```json
    {
        "error": "Invalid date format. Use YYYY-MM-DD"
    }
    ```

## Point of access of Docker Containers

- **Ruby API (REST API):**
  - Port: 4567 
  - Base URL: http://localhost:4567
  - Endpoint for Locations: /locations/
  - Endpoint for Temperature forecasts: /temperature_forecast/:slug/:start_date/:end_date
  - DB: admin

- **NodeJS Data Fetching Module:**
  - No specific port
  - DB: admin

- **MongoDB:**
  - Port: 27017

- **Mongo-Express:**
  - Port: 8081
  - Base URL: http://localhost:8081/
  - user: admin
  - password: admin
  - DB: admin

## Docker Environment Variables
You will find some docker environment variables in the `/docker/docker-compose.yml` file.

- **mongo:**
  - MONGO_INITDB_ROOT_USERNAME: admin #(set admin username)
  - MONGO_INITDB_ROOT_PASSWORD: admin #(set password)

- **mongo-express:**
  - ME_CONFIG_MONGODB_ADMINUSERNAME: admin                      #(admin username to connect DB)
  - ME_CONFIG_MONGODB_ADMINPASSWORD: admin                      #(password to connect DB)
  - ME_CONFIG_MONGODB_URL: mongodb://admin:admin@mongo:27017/   #(URL of mongoDB)

- **ruby-api-app:**
  - RACK_ENV: production    #(env variable to run application in docker container)

- **nodejs-fetch-module:**
  - MONGODB_URI: 'mongodb://admin:admin@mongo:27017/admin'  #(URL of mongoDB)
  - TIME_CRON: '50 18 * * *'  #(when execute the fetch-save/update data | use => MIN HOUR DAY MONTH WEEK)
  - LOGGER_DIR: logs                                        #(directory to save logs of app)

## Docker Images
When executing docker-compose up -d, Docker will automatically download the images hosted in my public DockerHub repository. However, if you prefer to download the image separately beforehand, you can use the following command:

- ```bash docker pull iglesias9627/node_js_fetching_module:v0.0.1```

- ```bash docker pull iglesias9627/ruby_api_sinatra:v0.0.2```

`iglesias9627/node_js_fetching_module:v0.0.1` docker image is the NodeJS application and `iglesias9627/ruby_api_sinatra:v0.0.2` is the Ruby REST API.  

## Ruby
The REST API application was developped using the Sinatra Framework in a modular way with Ruby version: 3.2.3.

If you want to run this application locally (in dev mode) go to `APPTWEAK_API/api` and execute in terminal:
```bash 
ruby dev.rb
```

## NodeJS
The application for daily fetching and saving temperature forecasts with Node version: 20.11.1. 

If you want to run this application locally (in dev mode) go to `APPTWEAK_API/nodejs_fetch_module` and execute in terminal:
```bash 
npm start
```