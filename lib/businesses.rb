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

    def find_all
      self.keys.collect{ |key| self[key] }
    end

    def [](key)
      Business.new(super)
    end

    def []=(key, value)
      super(key, value.nested_attributes)
    end

    def find_all_by_distance(location)
      find_all.sort_by{ |business| business.distance_from(location) }
    end

    def save!(business)
      fail 'Business is not vaild' unless business.nested_valid?
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
  end
end

