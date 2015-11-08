require 'spec_helper'

module Geo
  describe LoadBusinesses do
    let(:businesses) { Businesses.new(Businesses.memory_hash) }
    let(:data_string) { File.read('spec/offers_poi.tsv') }

    context 'when loading businesses' do
      it 'should read file' do
        LoadBusinesses.load_businesses(businesses, data_string)
        sorted = businesses.find_all_by_distance(Geo::verve_location)
        expect(sorted.size).to eq(202)
      end
    end
  end
end

