require 'sinatra'
require 'json'
require 'mongoid'
require_relative './models/location'
require_relative './helpers/api_helper.rb'
require_relative './helpers/date_helper.rb'

Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))

get '/' do
  # here we specify the content type to respond with
  content_type :json
  { message: "Welcome to API Sinatra + MongoDB"  }.to_json
end

post '/locations' do
  # here we specify the content type to respond with
  content_type :json
  # try-catch if an error occurs
  begin
    request_body = JSON.parse(request.body.read)
    latitude = request_body['latitude']
    longitude = request_body['longitude']
    slug = request_body['slug']

    location = Location.new(latitude: latitude, longitude: longitude, slug: slug)

    if location.save
      status 201
      { message: "Location created successfully", location: location }.to_json
    else
      status 422
      {errors: location.errors.full_messages }.to_json
    end
  rescue JSON::ParserError
    status 400
    { error: "Invalid JSON format in request body" }.to_json
  rescue StandardError => e
    status 500
    { error: "Internal server error: #{e.message}" }.to_json
  end
end

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

    location = Location.find_by(slug: slug)

    if location.nil?
      status 404
      return { error: "Location not found" }.to_json
    end

    list_dates = api_7timer_query(location, start_date, end_date)

    list_dates_filtered = filter_by_dates(start_date, end_date, list_dates)

    { response: list_dates_filtered  }.to_json
  rescue StandardError => e
    status 500
    { error: "Internal server error: #{e.message}" }.to_json
  end
end

not_found do
  content_type :json
  { status: 404, message: "Endpoint doesn't exists!" }.to_json
end
