require 'spec_helper'

module Geo
  describe Business do
    let(:business_params) {
      {
        name: 'Verve',
        phone: nil,
        radius: '5',
        address: {
          street: '5973 Avenida Encinas',
          street2: nil,
          city:   'Carlsbad',
          state:  'CA',
          country: 'US',
          zip:    '92008',
          zip_suffix: nil,
          location: { latitude: 3, longitude: 4 },
        }
      }
    }

    let(:business) { Business.new(business_params) }

    context 'when valid data is passed' do
      it 'should be an instance of Business' do
        expect(business.class).to eq(Business)
      end

      it 'should be valid' do
        expect(business).to be_valid
      end

      it 'location should be of type GeoLocation' do
        expect(business.location.class).to eq(GeoLocation)
      end

      it 'should calculate distance_from' do
        expect(business.distance_from(Geo::GeoLocation('1,2'))).to be_within(5).of(195)
      end

      it 'should have correct #nested_attribtes' do
        expect(business.nested_attributes).to eq(business_params)
      end
    end


    context 'when invalid data is passed' do
      it 'should be invalid when name is missing' do
        params = business_params.dup
        params.delete :name
        bus = Business.new(params)
        expect(bus).to_not be_valid
      end

      it 'should be invalid when street is missing' do
        params = Marshal.load(Marshal.dump(business_params))
        params[:address].delete :street
        bus = Business.new(params)
        expect(bus).to_not be_nested_valid
      end

      it 'should be invalid when latitude is not a number' do
        params = Marshal.load(Marshal.dump(business_params))
        params[:address][:location][:latitude] = 'a'
        bus = Business.new(params)
        expect(bus).to_not be_nested_valid
      end
    end
  end
end

