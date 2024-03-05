// Function to save temperatures in DB
async function saveTemperaturesInDB(location, forecastData, temperaturesCollection) {
    // Find the temperatures associated with the location
    const existingTemperatures = await temperaturesCollection.find({ location_models_id: location._id }).toArray();
  
    // Update or insert temperatures for each date
    for (const tempData of forecastData) {
      const existingTemperature = existingTemperatures.find(temp => temp.date === tempData.date);
  
      if (existingTemperature) {
        // Update existing temperature record
        await temperaturesCollection.updateOne(
          { _id: existingTemperature._id },
          { $set: { min_forecasted: tempData['min-forecasted'], max_forecasted: tempData['max-forecasted'] } }
        );
      } else {
        // Insert new temperature record
        await temperaturesCollection.insertOne({
          location_models_id: location._id,
          date: tempData.date,
          min_forecasted: tempData['min-forecasted'],
          max_forecasted: tempData['max-forecasted'],
          updated_at: new Date(),
          created_at: new Date(),
        });
      }
    }
  
    return { success: 'Documents saved successfully' };
  }
  
  module.exports = saveTemperaturesInDB;
  

module.exports = saveTemperaturesInDB