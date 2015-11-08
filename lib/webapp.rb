require 'sinatra'
require 'json'

require_relative 'geo'

# NOTE: you must have redis running on localhost w/o a password.

set :bind, '0.0.0.0'
set :port, 8080

def businesses
  unless $businesses
    $businesses = Geo::Businesses.new(Geo::Businesses.redis_hash)
    if true
      $stderr.puts "\nloading first two businesses"
      data_string = default_two_businesses_string
      Geo::LoadBusinesses.load_businesses($businesses, data_string)
    end
  end
  $businesses
end

def default_businesses_text
  txt = default_businesses_string
  lines = txt.split("\r")
  lines.join("\n")
end

def default_businesses_string
  Geo::LoadBusinesses.default_business_text
end

def default_two_businesses_string
  str = default_businesses_string
  lines = str.split("\r")
  lines[0..2].join("\r")
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

get '/businesses_text.json' do
  $stderr.puts "\ngetting business text"
  content_type :json
  { businessText: default_businesses_text }.to_json
end

post '/new_businesses' do
  $stderr.puts "\nadding new businesses"
  txt = (params['data'])
  txt = txt.split("\n").join("\r")
  Geo::LoadBusinesses.load_businesses($businesses, txt)
  'ok'
end

post '/delete_businesses' do
  $stderr.puts "\ndeleting all businesses"
  businesses.clear_all!
  'ok'
end

