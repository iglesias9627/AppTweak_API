require 'mongoid'
require_relative './location_model'

class TemperatureModel
  include Mongoid::Document
  field :date, type: String
  field :min_forecasted, type: Integer
  field :max_forecasted, type: Integer

  belongs_to :location
end
