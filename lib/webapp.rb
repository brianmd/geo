require 'sinatra'
require 'json'

require_relative 'geo'

def businesses
  unless @businesses
    $stderr.puts Geo::Businesses.memory_hash
    @businesses = Geo::Businesses.new(Geo::Businesses.memory_hash)
    $stderr.puts @businesses.inspect
    data_string = File.read('spec/offers_poi.tsv')
    $stderr.puts data_string, data_string.size
    @businesses.load(data_string)
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

