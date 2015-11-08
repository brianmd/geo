require 'delegate'
require 'csv'

module Geo
  class Businesses < SimpleDelegator
    def self.memory_hash(name=default_name)
      require 'collectr/memory/memory_hash'
      Collectr::MemoryHash.new name
    end

    def self.redis_hash(name=default_name)
      require 'collectr/redis/redis_hash'
      Collectr::RedisHash.new name
    end

    def load(data_string)
      is_first_row = true
      CSV.parse(data_string, { :col_sep => "\t" }) do |row|
        if is_first_row
          is_first_row = false
          next if row.size<5 or row[0]=='name'
        end
        row = row.collect{ |col| col.class==String ? col.strip : col }
        params = {
          name: row[0],
          phone: row[5],
          radius: row[8],
          address: {
            street: row[1],
            street2: row[2],
            # city: 'city',
            # state: 'state',
            country: 'US',
            zip: row[3],
            zip_suffix: row[4],
            location: {
              latitude: row[6],
              longitude: row[7]
            },
          }
        }
        business = Business.new(params)
        self.save!(business)
      end
    end

    def find_all
      self.keys.collect{ |key| self[key] }
    end

    def find_all_by_distance(location)
      find_all.sort_by{ |business| business.distance_from(location) }
    end

    def save!(business)
      # self[[business.address.street, business.location.to_a]] = business
      self[business.key] = business
    end

    def clear_all!
      self.clear
    end

    def to_hash(location=nil)
      array = location.nil? ? find_all : find_all_by_distance(location)
      array.collect do |business|
        business.to_hash(location)
      end
    end

    private

    def self.default_name
      'geo_businesses'
    end


# require 'oat'
# class BusinessSerializer < Oat::Serializer
  # schema do
    # link :self, href: product_url(item)

    # properties do |props|
      # props.title item.title
      # props.price item.price
      # props.description item.blurb
    # end
  # end

# end


  end
end

