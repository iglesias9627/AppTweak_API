const axios = require('axios');
const logger = require('../logger');

const childLogger = logger.child({ module: 'sevenTimerService.js' });

async function makeApiCall(latitude, longitude) {
    const apiURL = `https://www.7timer.info/bin/astro.php?lon=${longitude}&lat=${latitude}&ac=0&unit=metric&output=json&tzshift=0`;
    try {
        childLogger.info('We retrieve data from 7 timer API');
        const response = await axios.get(apiURL);
        return response.data;
    } catch (error) {
        childLogger.error('Error making API call:', error);
        throw error;
    }
}

module.exports = makeApiCall;
