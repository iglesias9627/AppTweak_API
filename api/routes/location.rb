require 'sinatra/base'
require 'json'
require 'mongoid'
require_relative '../helpers/api_helper'
require_relative '../helpers/date_helper'
require_relative '../models/location_model'

module Routes
  class Location < Sinatra::Base
    post '/locations' do
      content_type :json

      begin
        request_body = JSON.parse(request.body.read)
        latitude = request_body['latitude']
        longitude = request_body['longitude']
        slug = request_body['slug']

        location = LocationModel.new(latitude: latitude, longitude: longitude, slug: slug)

        if location.save
          status 201
          { message: "Location created successfully", location: location }.to_json
        else
          status 422
          { errors: location.errors.full_messages }.to_json
        end
      rescue JSON::ParserError
        status 400
        { error: "Invalid JSON format in request body" }.to_json
      rescue StandardError => e
        status 500
        { error: "Internal server error: #{e.message}" }.to_json
      end
    end
  end
end
