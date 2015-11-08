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
        phone: '123-456-7890',
        radius: '5',
        address: {
          street: street,
          street2: nil,
          city:   'Carlsbad',
          state:  'CA',
          country: 'US',
          zip:    '92008',
          zip_suffix: nil,
          location: { latitude: lat_long[0], longitude: lat_long[1] },
        }
      }
    }

    let(:business) { Business.new(business_params) }
    let(:key) { business.key }
    let(:business2) {
      params = Marshal.load(Marshal.dump(business_params))
      params[:name] = 'Verve2'
      params[:address][:city] = 'Carls'
      params[:address][:location][:latitude] = 33
      Business.new(params)
    }

    context 'when businesses is empty' do
      before(:each) { businesses.clear_all! }

      it 'should be able to add an item' do
        businesses[:a] = business
        expect(businesses[:a].name).to eq('Verve')
      end

      it 'find_all should work' do
        businesses[:a] = business
        businesses[:b] = business2
        expect(businesses.keys).to eq([:a,:b])
        expect(businesses.find_all.first.nested_attributes).to eq(business_params)
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
        businesses.save!(verve)
        expect(businesses.size).to eq(2)
        new_verve = businesses[key]
        expect(new_verve.class).to eq(Business)
        expect(new_verve.address.city).to eq('C')
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
  end
end

