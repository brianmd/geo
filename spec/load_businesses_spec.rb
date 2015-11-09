require 'spec_helper'

module Geo
  describe LoadBusinesses do
    before(:each) {
      @businesses = Businesses.new(Businesses.memory_hash)
    }
    let(:data_string) { File.read('spec/offers_poi.tsv') }

    context 'when loading businesses' do
      it 'should read file' do
        LoadBusinesses.load_businesses(@businesses, data_string)
        sorted = @businesses.find_all_by_distance(Geo::verve_location)
        expect(sorted.size).to eq(202)
      end

      it 'should return row numbers of errors' do
        data = data_string.gsub('-93.5773', 'a')
        data = data.gsub('45.159803', 'g')
        errors = LoadBusinesses.load_businesses(@businesses, data)
        expect(errors).to eq([4,18])
        sorted = @businesses.find_all_by_distance(Geo::verve_location)
        expect(sorted.size).to eq(202-2)
      end
    end
  end
end

