module Geospatial
  extend ActiveSupport::Concern

  METERS_PER_MILE = 1609.34

  included do
    before_save :set_lonlat
  end

  def lon
    @lon || lonlat.try(:x)
  end

  def lon=(lon)
    @lon = lon
  end

  def lat
    @lat || lonlat.try(:y)
  end

  def lat=(lat)
    @lat = lat
  end

  def within_range?(other, miles)
    meters = miles * METERS_PER_MILE
    lonlat.distance(other.lonlat) <= meters
  end

  module ClassMethods
    def within_range(other, miles)
      meters = miles * METERS_PER_MILE
      where("ST_DWithin(lonlat, ?, ?)", other.lonlat, meters)
    end
  end

  private
  def set_lonlat
    self.lonlat = "POINT(#{lon} #{lat})" if @lon && @lat
  end
end
