require 'mongoid'
require_relative './temperature_model'

class LocationModel
  include Mongoid::Document
  include Mongoid::Timestamps

  field :latitude, type: Float
  field :longitude, type: Float
  field :slug, type: String

  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9_-]+\z/i }

  has_many :temperatures
end
