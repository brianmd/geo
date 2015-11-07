module Geo
  class Business
    include Virtus.model
    include ActiveModel::Validations

    attribute :name, String

    attribute :address, Address

    validates :name, :address, presence: true

    def location
      address.location
    end

    def distance_from(other_location)
      address.distance_from(other_location)
    end
  end
end

