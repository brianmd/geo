require 'delegate'

module Geo
  class Businesses < SimpleDelegator
    def self.memory_hash
      require 'collectr/memory/memory_hash'
      Collectr::MemoryHash.new businesses_name
    end

    def self.redis_hash
      require 'collectr/redis/redis_hash'
      Collectr::RedisHash.new businesses_name
    end

    def find_all
      self.keys.collect{ |key| self[key] }
    end

    def save!(business)
      self[business.name] = business
    end

    def clear_all!
      self.clear
    end

    private

    def self.businesses_name
      'geo_businesses'
    end
  end
end

