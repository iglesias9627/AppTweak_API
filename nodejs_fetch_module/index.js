const fetchAndUpsertTemperatures = require('./src/api_fetch/fetch')
const logger = require('./src/logger');
const cron = require('node-cron');

const childLogger = logger.child({ module: 'index.js' });
const timeCron = process.env.TIME_CRON || '39 18 * * *';

childLogger.info('Aplication started...');

cron.schedule(timeCron, () => {
    childLogger.info('Running the temperature forecasts update task...');
    fetchAndUpsertTemperatures();
}, {
    timezone: 'Europe/Brussels'
});

