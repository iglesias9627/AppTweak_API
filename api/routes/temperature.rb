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
          return { error: "Start date must be #{Date.today.strftime('%Y-%m-%d')}" }.to_json
        end

        # Validate date range
        unless valid_date_range(start_date, end_date)
          status 400
          return { error: 'Date range is more than 3 days' }.to_json
        end

        location = LocationModel.find_by(slug: slug)

        list_dates = api_7timer_query(location, start_date, end_date)

        list_dates_filtered = filter_by_dates(start_date, end_date, list_dates)

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
