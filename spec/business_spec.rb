require 'spec_helper'

module Geo
  describe Business do
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

    context 'when valid data is passed' do
      it 'should be an instance of Business' do
        expect(business.class).to eq(Business)
      end

      it 'should be valid' do
        expect(business).to be_valid
      end

      it 'should calculate distance_from' do
        expect(business.distance_from(Geo::GeoLocation('1,2'))).to be_within(5).of(195)
      end
    end
  end
end

