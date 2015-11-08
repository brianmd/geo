require 'sinatra'
require 'json'

require_relative 'geo'

# NOTE: you must have redis running on localhost w/o a password.

def businesses
  unless $businesses
    $businesses = Geo::Businesses.new(Geo::Businesses.redis_hash)
    if true
      $stderr.puts 'loading businesses  !!!!!!!!!!!!!!!!!!!!!!!'
      data_string = default_businesses_string
      Geo::LoadBusinesses.load_businesses($businesses, data_string)
    end
  end
  $businesses
end

def default_businesses_string
  File.read('spec/offers_poi.tsv')
end

set :bind, '0.0.0.0'
set :port, 8080

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

post '/delete_businesses' do
  $stderr.puts 'deleting !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
  businesses.clear_all!
  'ok'
end

