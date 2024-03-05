const { MongoClient } = require('mongodb');
const logger = require('../logger');

const childLogger = logger.child({ module: 'connect.js' });

async function connectToMongoDB() {
    const uri = process.env.MONGODB_URI || 'mongodb://admin:admin@localhost:27017/admin';
    const client = new MongoClient(uri);

    try {
        await client.connect();
        childLogger.info('Connected to MongoDB!');
        return client.db();
    } catch (error) {
        childLogger.info('Error connecting to MongoDB:', error);
        throw error;
    }
}

module.exports = connectToMongoDB;
