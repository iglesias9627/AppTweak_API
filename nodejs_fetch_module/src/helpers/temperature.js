
function calculateMaxMinTemperatureByDate(weatherData) {
    // Array to store forecasted data for each day
    const forecastData = [];
  
    // Iterate through the dataseries to extract temperatures
    weatherData.dataseries.forEach((entry) => {
      const timepoint = entry.timepoint;
      const temperature = entry.temp2m;
  
      // Convert timepoint to Date
      const dt = timepointToDateTime(weatherData.init, timepoint);
  
      // Extract date from Date object 2022-03-05T12:30:00.000Z
      const day = dt.toISOString().split('T')[0];
  
      // Update max and min temperatures for the date 
      const forecastDay = forecastData.find((forecast) => forecast.date === day);
      if (!forecastDay) {
        forecastData.push({ 'date': day, 'min-forecasted': temperature, 'max-forecasted': temperature });
      } else {
        forecastDay['min-forecasted'] = Math.min(forecastDay['min-forecasted'], temperature);
        forecastDay['max-forecasted'] = Math.max(forecastDay['max-forecasted'], temperature);
      }
    });
  
    return forecastData;
}
  
function timepointToDateTime(init, timepoint) {
    const initDate = new Date(init.substring(0, 4), init.substring(4, 6) - 1, init.substring(6, 8), init.substring(8, 10), 0, 0, 0);
    const timestamp = initDate.getTime() + (timepoint * 3600 * 1000); // Convert hours to milliseconds
    return new Date(timestamp);
}
  

module.exports = calculateMaxMinTemperatureByDate;
  