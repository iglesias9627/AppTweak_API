def retrieve_temperatures_from_db(location, start_date_str, end_date_str)
  temperatures_from_db = location.temperature_models.where(date: { '$gte' => start_date_str, '$lte' => end_date_str })
  list_temperatures = temperatures_from_db.map do |temperature|
    {
      'date' => temperature.date,
      'min-forecasted' => temperature.min_forecasted,
      'max-forecasted' => temperature.max_forecasted
    }
  end
  return list_temperatures
end

def save_temperatures_in_db(location, list_dates)
  list_dates.each do |temp_data|
    temperature = location.temperature_models.find_or_initialize_by(date: temp_data['date'])
    temperature.min_forecasted = temp_data['min-forecasted']
    temperature.max_forecasted = temp_data['max-forecasted']
    unless temperature.save
      status 400
      return {error: "Error saving record: #{temperature.errors.full_messages.join(', ')}"}.to_json
    end
  end
end
