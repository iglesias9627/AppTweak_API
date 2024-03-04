require 'net/http'

# Function to calculate max-min forecasted temperatures by date in a date range
def calculate_max_min_temperature_by_date(weather_data)
  # Array to store forecasted data for each day
  forecast_data = []

  # Iterate through the dataseries to extract temperatures
  weather_data['dataseries'].each do |entry|
    timepoint = entry['timepoint']
    temperature = entry['temp2m']

    # Convert timepoint to DateTime
    dt = timepoint_to_datetime(weather_data['init'], timepoint)

    # Extract day from DateTime
    day = dt.strftime('%Y-%m-%d')

    # Update max and min temperatures for the day
    forecast_day = forecast_data.find { |forecast| forecast['date'] == day }
    if forecast_day.nil?
      forecast_day = { 'date' => day, 'min-forecasted' => temperature, 'max-forecasted' => temperature }
      forecast_data << forecast_day
    else
      forecast_day['min-forecasted'] = [forecast_day['min-forecasted'], temperature].min
      forecast_day['max-forecasted'] = [forecast_day['max-forecasted'], temperature].max
    end
  end

  return forecast_data
end

# Function to make API call to 7timer API
def api_7timer_query(location, start_date, end_date)
  begin
    # Get longitude and latitude values
    lon = location.longitude
    lat = location.latitude

    # API URL
    api_url = "https://www.7timer.info/bin/astro.php?lon=#{lon}&lat=#{lat}&ac=0&unit=metric&output=json&tzshift=0"

    # Make the API request
    uri = URI(api_url)
    response = Net::HTTP.get(uri)

    # Parse the JSON response
    weather_data = JSON.parse(response)

    list_max_min_temperatures_by_dates = calculate_max_min_temperature_by_date(weather_data)

    return list_max_min_temperatures_by_dates
  rescue StandardError => e
    # Handle the exception
    puts "Error in API function: #{e.message}"
    return { error: "Error: #{e.message}" }
  end
end
