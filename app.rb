# puts 'Hello world'
# app.rb

require 'sinatra'
require 'json'

puts "My application is running in: http://localhost:4567/"

get '/' do
  # here we specify the content type to respond with
  content_type :json

  { message: "Hello world!"}.to_json
end
