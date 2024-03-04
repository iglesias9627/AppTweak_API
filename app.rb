require 'sinatra/base'
require 'mongoid'
require_relative './routes/location'
require_relative './routes/temperature'
require_relative './models/location_model'
require_relative './models/temperature_model'

module App
  class SinatraApi < Sinatra::Base
    Mongoid.load!('./config/mongoid.yml', :development)

    use Routes::Location
    use Routes::Temperature

    get '/' do
      content_type :json
      { message: "Welcome to API Sinatra + MongoDB"  }.to_json
    end

    not_found do
      content_type :json
      { status: 404, message: "Endpoint doesn't exists!" }.to_json
    end
  end
end
#App.run!
