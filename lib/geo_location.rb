module Geo
  class GeoLocation
    include Virtus.model

    attribute :latitude, Float
    attribute :longitude, Float

    def distance_from(other_location)
      dist = GeoDistance::Haversine.geo_distance(latitude, longitude, other_location.latitude, other_location.longitude)
      dist.as_miles
    end
  end

  def GeoLocation(location)
    case location
    when GeoLocation
      return location
    when String
      tokens = location.split(',')
      lat  = Float(tokens[0])
      long = Float(tokens[1])
      return GeoLocation.new latitude: lat, longitude: long
    else
      fail 'Unable to coerce into GeoLocation'
    end
  end

  def verve_location
    GeoLocation('33.1243208, -117.32582479999996')
  end

  module_function :GeoLocation, :verve_location
end

