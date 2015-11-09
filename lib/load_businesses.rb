require 'delegate'
require 'csv'

module Geo
  class LoadBusinesses
    def self.load_businesses(businesses_instance, businesses_string)
      is_first_row = true
      errors = []
      row_num = 0
      CSV.parse(businesses_string, { :col_sep => "\t" }) do |row|
        begin
          row_num = row_num + 1
          if is_first_row
            is_first_row = false
            next if row.size<5 or row[0]=='name'
          end
          next if row.length<5
          business = build_business(row)
          fail unless business.nested_valid?
          businesses_instance.save!(business)
        rescue
          errors << row_num
        end
      end
      errors
    end

    def self.default_business_text
      File.read('spec/offers_poi.tsv')
    end

    private

    def self.build_business(row)
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

      Business.new(params)
    end
  end
end

