require 'sinatra/base'
require 'json'
require 'mongoid'
require_relative '../helpers/api_helper'
require_relative '../helpers/date_helper'
require_relative '../models/location_model'
require_relative '../models/temperature_model'
require_relative '../services/temperature_db'

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

        unless location = LocationModel.find_by(slug: slug)
          status 400
          return { error: "Location: #{slug} not found in database!"}.to_json
        end

        if location.temperature_models.exists?(date: start_date) == true && location.temperature_models.exists?(date: end_date) == true
          # Data already exists in the database for the specified date range
          temperatures = retrieve_temperatures_from_db(location, start_date, end_date)
          puts "#{start_date} exists in DB and #{end_date} exists in DB"
          return { response: temperatures }.to_json

        elsif location.temperature_models.exists?(date: start_date) == false && location.temperature_models.exists?(date: end_date) == true
          status 404
          return { error: "Temperature for start date: #{start_date} NOT exists in DB, temperature for end date: #{end_date} exists in DB" }.to_json

        elsif location.temperature_models.exists?(date: start_date) == true && location.temperature_models.exists?(date: end_date) == false
          puts "#{start_date} exists in DB and #{end_date} NOT exists in DB"
          today = Date.today
          max_allowed_date = today + 3
          parsed_end_date = Date.parse(end_date)
          if parsed_end_date == today || parsed_end_date <= max_allowed_date
            # We retreive data from 7 Timer API and we save in database
            puts "End date is in the range and we can call the 7 timer API"
            list_dates = api_7_timer_query(location)
            save_temperatures_in_db(location, list_dates)
            temperatures = retrieve_temperatures_from_db(location, start_date, end_date)
            return { response: temperatures }.to_json
          else
            status 400
            return { error: "We can not retrieve the data for end date: #{end_date}" }.to_json
          end

        elsif location.temperature_models.exists?(date: start_date) == false && location.temperature_models.exists?(date: end_date) == false
          puts "#{start_date} NOT exists in DB and #{end_date} NOT exists in DB"
          puts "We verify if we can retrieve data from API"

          # Validate start date
          unless valid_start_date_today(start_date)
            status 400
            today = Date.today
            return { error: "Start date must be from #{today.strftime('%Y-%m-%d')}" }.to_json
          end

          # Validate date range
          unless valid_date_range(start_date, end_date)
            status 400
            return { error: 'Date range is more than 3 days' }.to_json
          end

          list_dates = api_7_timer_query(location)
          save_temperatures_in_db(location, list_dates)
          temperatures = retrieve_temperatures_from_db(location, start_date, end_date)
          return { response: temperatures }.to_json

        end

      rescue StandardError => e
        status 500
        { error: "Internal server error: #{e.message}" }.to_json
      end
    end
  end
end
