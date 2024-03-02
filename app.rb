# main.rb

require 'sinatra'
require 'json'

get '/' do
# here we specify the content type to respond with
  content_type :json
  { item: 'Red Dead Redemption 2', price: 19.79, status: 'Available'  }.to_json
end

not_found do
  content_type :json

  { status: 404, message: "Nothing Found!" }.to_json
end
