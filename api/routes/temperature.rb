require 'sinatra/base'
require 'json'
require 'mongoid'
require_relative '../helpers/api_helper'
require_relative '../helpers/date_helper'
require_relative '../models/location_model'
require_relative '../models/temperature_model'

module Routes
  class Temperature < Sinatra::Base

    get '/temperature_forecast/:slug/:start_date/:end_date' do
      content_type :json

      begin
        slug = params[:slug]
        start_date = params[:start_date]
        end_date = params[:end_date]

        # Validate date formats
        unless valid_date_format(start_date) && valid_date_format(end_date)
          status 400
          return { error: 'Invalid date format. Use YYYY-MM-DD' }.to_json
        end

        # Validate date start and end
        unless valid_date_start_end(start_date, end_date)
          status 400
          return { error: 'End date must be after the start date' }.to_json
        end

        # Validate start date
        unless valid_start_date_today(start_date)
          status 400
          today = Date.today
          max_allowed_date = today + 2
          return { error: "Start date must be from #{today.strftime('%Y-%m-%d')} until #{max_allowed_date.strftime('%Y-%m-%d')} " }.to_json
        end

        # Validate date range
        unless valid_date_range(start_date, end_date)
          status 400
          return { error: 'Date range is more than 3 days' }.to_json
        end

        list_dates_filtered = []

        location = LocationModel.find_by(slug: slug)

        # Check if data already exists in the database for the specified date range
        existing_temperatures = location.temperature_models.where(date: { '$gte' => start_date, '$lte' => end_date })

        if existing_temperatures.any?
          # Data exists in the database, retrieve and return it
          list_dates_filtered = existing_temperatures.map do |temperature|
            {
              'date' => temperature.date,
              'min-forecasted' => temperature.min_forecasted,
              'max-forecasted' => temperature.max_forecasted
            }
          end
        else
          # Data doesn't exists in database so we retreive data from 7Timer API and we save in database
          list_dates = api_7_timer_query(location, start_date, end_date)

          list_dates.each do |temp_data|
            temperature = location.temperature_models.find_or_initialize_by(date: temp_data['date'])
            temperature.min_forecasted = temp_data['min-forecasted']
            temperature.max_forecasted = temp_data['max-forecasted']
            unless temperature.save
              status 400
              return {error: "Error saving record: #{temperature.errors.full_messages.join(', ')}"}.to_json
            end
          end
          list_dates_filtered = filter_by_dates(start_date, end_date, list_dates)
        end

        { response: list_dates_filtered  }.to_json

      rescue  Mongoid::Errors::DocumentNotFound => e
        status 404
        { error: 'Location not found' }.to_json

      rescue StandardError => e
        status 500
        { error: "Internal server error: #{e.message}" }.to_json
      end
    end
  end
end
