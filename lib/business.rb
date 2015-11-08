module Geo
  class Business
    include Virtus.model
    include ActiveModel::Validations

    attribute :name, String
    attribute :phone, String
    attribute :radius, String

    attribute :address, Address

    validates :name, :address, presence: true

    def key
      [address.street, address.location.to_a]
    end

    def location
      address.location
    end

    def distance_from(other_location)
      address.distance_from(other_location)
    end

    def to_hash(location=nil)
      hash = {
        name: name,
        phone: phone,
        radius: radius,
        street: address.street,
        street2: address.street2,
        zip: address.zip,
        zip_suffix: address.zip_suffix,
        latitude: address.location.latitude,
        longitude: address.location.longitude,
      }
      hash[:distance] = distance_from(location) if location
      hash
    end

    def nested_attributes
      result = attributes
      result[:address] = self.address.attributes
      result[:address][:location] = address.location.attributes
      result
    end
  end
end

