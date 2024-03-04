require 'sinatra/base'
require 'mongoid'
require_relative './routes/location'
require_relative './routes/temperature'
require_relative './models/location_model'
require_relative './models/temperature_model'

module App
  class SinatraApi < Sinatra::Base
    configure do
      if ENV['RACK_ENV'] == 'production'
        Mongoid.load!('./config/mongoid.yml', :production)
      else
        Mongoid.load!('./config/mongoid.yml', :development)
      end
    end

    use Routes::Location
    use Routes::Temperature

    get '/' do
      content_type :json
      { message: "Welcome to API Sinatra + MongoDB"  }.to_json
    end

    not_found do
      content_type :json
      status 404
      { error: "Endpoint doesn't exists!" }.to_json
    end
  end
end
#App.run!
