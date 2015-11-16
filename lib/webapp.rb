require 'sinatra'
require 'json'

require_relative 'geo'

# NOTE: you must have redis running on localhost w/o a password.

set :bind, '0.0.0.0'
set :port, 8080

def businesses
  unless $businesses
    $businesses = Geo::Businesses.new(Geo::Businesses.memory_hash)
    $stderr.puts "\nloading first five businesses"
    data_string = businesses_string(5)
    Geo::LoadBusinesses.load_businesses($businesses, data_string)
  end
  $businesses
end

def default_businesses_text
  txt = default_businesses_string
  txt.gsub("\r", "\n")
end

def default_businesses_string
  Geo::LoadBusinesses.default_business_text
end

def businesses_string(num_rows)
  str = default_businesses_string
  lines = str.split("\r")
  lines[0..num_rows].join("\r")
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
  content_type :json
  txt = (params['data'])
  txt = txt.gsub("\n", "\r")
  errors = Geo::LoadBusinesses.load_businesses($businesses, txt)
  $stderr.puts 'errors', errors.inspect
  if errors.empty?
    { errors: [] }.to_json
  else
    status 400
    { errors: errors }.to_json
  end
end

post '/delete_businesses' do
  $stderr.puts "\ndeleting all businesses"
  businesses.clear_all!
  'ok'
end

