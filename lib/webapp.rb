require 'sinatra'
require 'json'

require_relative 'geo'

# NOTE: you must have redis running on localhost w/o a password.

def businesses
  unless @businesses
    @businesses = Geo::Businesses.new(Geo::Businesses.redis_hash)
    data_string = File.read('spec/offers_poi.tsv')
    Geo::LoadBusinesses.load_businesses(@businesses, data_string)
  end
  @businesses
end

get '/version' do
  Geo::VERSION
end

get '/businesses.json' do
  latitude = Float(params[:latitude] || 33.1243208)
  longitude = Float(params[:longitude] || -117.32582479999996)
  distance_from_location = Geo::GeoLocation.new(latitude: latitude, longitude: longitude)
  json = businesses.to_hash(distance_from_location)

  content_type :json
  { location: [latitude, longitude], businesses: json }.to_json
end

