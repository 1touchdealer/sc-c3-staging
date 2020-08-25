class Region < ActiveRecord::Base
  include Geospatial

  has_many :businesses
  has_many :churches
  has_many :alliances
  has_many :events
  has_many :ads
  has_many :campaigns
end
