class Location < ActiveRecord::Base
  include Geospatial

  belongs_to :locationable, polymorphic: true
end
