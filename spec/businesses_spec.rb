require 'spec_helper'

require 'pathname'

module Geo
  describe Businesses do
    let(:businesses) { Businesses.new(Businesses.memory_hash) }

    let(:street) { '5973 Avenida Encinas' }
    let(:lat_long) { [3.0, 4.0] }

    let(:business_params) {
      {
        name: 'Verve',
        address: {
          street: street,
          city:   'Carlsbad',
          state:  'CA',
          country: 'US',
          zip:    '92008',
          location: { latitude: lat_long[0], longitude: lat_long[1] },
        }
      }
    }

    let(:business) { Business.new(business_params) }
    let(:key) { business.key }
    let(:business2) {
      params = business_params
      params[:name] = 'Verve2'
      params[:address][:city] = 'Carls'
      params[:address][:location][:latitude] = 33
      Business.new(params)
    }

    context 'when businesses is empty' do
      it 'should be able to add an item' do
        businesses[:a] = 3
        expect(businesses[:a]).to eq(3)
      end

      it 'find_all should work' do
        businesses[:a] = 3
        businesses[:b] = 5
        expect(businesses.keys).to eq([:a,:b])
        expect(businesses.find_all).to eq([3,5])
      end

      it 'should be able to add real businesses' do
        businesses.save!(business)
        verve = businesses[key]
        expect(verve.class).to eq(Business)
        expect(verve.address.city).to eq('Carlsbad')
      end

      it 'should overwrite a business (key is business street, lat, and long)' do
        businesses.save!(business)
        businesses.save!(business2)
        verve = businesses[business.key]
        expect(verve.class).to eq(Business)
        expect(verve.address.city).to eq('Carlsbad')
        verve.address.city = 'C'
        businesses.save!(business)
        expect(businesses.size).to eq(2)
        verve = businesses[key]
        expect(verve.class).to eq(Business)
        expect(verve.address.city).to eq('C')
      end

      it 'should be able to clear all businesses' do
        businesses.save!(business)
        businesses.save!(business2)
        expect(businesses.size).to eq(2)
        businesses.clear_all!
        expect(businesses.size).to eq(0)
      end

      it 'should be able to sort by distance' do
        businesses.save!(business)
        businesses.save!(business2)
        sorted = businesses.find_all_by_distance(Geo::verve_location)

        expect(businesses.find_all[0].name).to eq('Verve')
        # order should change because verve2 is closer than verve.
        expect(sorted[0].name).to eq('Verve2')
      end
    end

    context 'when loading businesses' do
      let(:data_string) { File.read('spec/offers_poi.tsv') }

      it 'should read file' do
        # expect(Pathname.new('.').realpath).to eq(3)
        businesses.load(data_string)
        # set = businesses.find_all.collect{|b| b.name}.to_set
        # expect(set).to eq(3)
        sorted = businesses.find_all_by_distance(Geo::verve_location)
        expect(sorted.size).to eq(202)
      end
    end
  end
end

