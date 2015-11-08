module Geo
  class Address
    include Virtus.model
    include ActiveModel::Validations

    attribute :street, String
    attribute :street2, String
    attribute :city, String
    attribute :state, String
    attribute :country, String
    attribute :zip, String
    attribute :zip_suffix, String

    attribute :location, GeoLocation

    validates :street, :zip, presence: true

    def nested_valid?
      valid? and location.valid?
    end

    def distance_from(other_location)
      fail 'This address does not have a location to find determine the distance' unless location
      location.distance_from(other_location)
    end
  end
end
