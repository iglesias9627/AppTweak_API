const connectToMongoDB = require('../db/connect');
const makeApiCall = require('../services/sevenTimerService');
const calculateMaxMinTemperatureByDate = require('../helpers/temperature')
const saveTemperaturesInDB = require('../services/temperatureDb')
const logger = require('../logger');

const childLogger = logger.child({ module: 'fetch.js' });

async function fetchAndUpsertTemperatures() {
    const db = await connectToMongoDB();
    const locationsCollection = db.collection('location_models');
    const temperaturesCollection = db.collection('temperature_models');

    const locations = await locationsCollection.find().toArray();

    for (const location of locations) {
        childLogger.info(`Fetching and upserting data for location: ${location['slug']}`);
        const { latitude, longitude } = location;
        const apiData = await makeApiCall(latitude, longitude);
        list_of_temperatures = calculateMaxMinTemperatureByDate(apiData);
        const result = await saveTemperaturesInDB(location, list_of_temperatures, temperaturesCollection);
        childLogger.debug(`The result: ${result}`);
    }
    childLogger.info('Data fetching and upserting completed!');
    // Close MongoDB connection
    await db.client.close();
    childLogger.info('Mongo connection closed.');
    childLogger.info('Waiting for the next time to fetch...');
}

module.exports = fetchAndUpsertTemperatures

