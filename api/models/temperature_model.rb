require 'mongoid'
require_relative './location_model'

class TemperatureModel
  include Mongoid::Document
  include Mongoid::Timestamps
  validates_presence_of :min_forecasted, :max_forecasted
  field :date, type: String
  field :min_forecasted, type: Integer
  field :max_forecasted, type: Integer

  belongs_to :location_models
end
