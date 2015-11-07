require 'spec_helper'

module Geo
  describe Businesses do
    let(:businesses) { Businesses.new(Businesses.memory_hash) }

    let(:business_params) {
      {
        name: 'Verve',
        address: {
          street: '5973 Avenida Encinas',
          city:   'Carlsbad',
          state:  'CA',
          country: 'US',
          zip:    '92008',
          location: { latitude: 3, longitude: 4 },
        }
      }
    }

    let(:business) { Business.new(business_params) }
    let(:business2) {
      params = business_params
      params[:name] = 'Verve2'
      params[:address][:city] = 'Carls'
      Business.new(params)
    }

    context 'when fresh object' do
      it 'should contain a memory hash' do
        businesses[:a] = 3
        expect(businesses[:a]).to eq(3)
      end

      it 'find_all should work' do
        businesses[:a] = 3
        businesses[:b] = 5
        expect(businesses.keys).to eq([:a,:b])
        expect(businesses.find_all).to eq([3,5])
      end

      it 'should add real businesses' do
        businesses.save!(business)
        verve = businesses['Verve']
        expect(verve.class).to eq(Business)
        expect(verve.address.city).to eq('Carlsbad')
      end

      it 'should overwrite business (key is business name)' do
        businesses.save!(business)
        businesses.save!(business2)
        verve = businesses['Verve']
        expect(verve.class).to eq(Business)
        expect(verve.address.city).to eq('Carlsbad')
        verve.address.city = 'C'
        businesses.save!(business)
        expect(businesses.size).to eq(2)
        verve = businesses['Verve']
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
    end
  end
end

