require 'spec_helper'

module Geo
  describe Address do
    let(:addr_params) {
      {
        street: '5973 Avenida Encinas',
        city:   'Carlsbad',
        state:  'CA',
        country: 'US',
        zip:    '92008',
        location: { latitude: 3, longitude: 4 },
      }
    }

    let(:addr) { Address.new(addr_params) }

    context 'when valid data is passed' do
      it 'should be an instance of Address' do
        expect(addr.class).to eq(Address)
      end

      it 'should have the correct city' do
        expect(addr.city).to eq('Carlsbad')
      end

      it 'should be valid' do
        expect(addr).to be_valid
      end

      it 'the location should be of type GeoLocation' do
        expect(addr.location.class).to eq(GeoLocation)
      end

      it 'should have the correct latitude' do
        expect(addr.location.latitude).to eq(3)
      end

      it 'should calculate distance_from' do
        expect(addr.distance_from(Geo::GeoLocation('1,2'))).to be_within(5).of(195)
      end
    end

    context 'when zip is missing' do
      let(:addr) {
        params = addr_params
        params.delete :zip
        Address.new(addr_params)
      }

      it 'should not be valid' do
        expect(addr.class).to eq(Address)
        expect(addr).to_not be_valid
      end
    end

    context 'when location is missing' do
      let(:addr) {
        params = addr_params
        params.delete :location
        Address.new(addr_params)
      }

      it 'should be valid' do
        expect(addr.class).to eq(Address)
        expect(addr).to be_valid
      end

      it 'should raise error when attepting #distance_from' do
        expect{ addr.distance_from(Geo::GeoLocation('1,2')) }.to raise_error(RuntimeError)
      end
    end
  end
end

