require 'spec_helper'

module Geo
  describe GeoLocation do
    let(:verve) { Geo::verve_location }

    context 'when instantiated from a string' do
      it 'should be an instance of GeoLocation' do
        expect(verve.class).to eq(GeoLocation)
      end

      it 'GeoLocation() should return itself' do
        expect(Geo::GeoLocation(verve)).to eq(verve)
      end

      it 'should have acceptable precision' do
        expect(verve.latitude).to be_within(0.0000001).of(33.1243208)
      end

      it 'should calculate the correct distance' do
        home = Geo::GeoLocation('35.149005,-106.5770737')
        miles = verve.distance_from(home)
        expect(miles).to be_within(0.000000001).of(630.2960908921099)
      end
    end

    context 'when invalid parameter is passed' do
      it 'should raise an error' do
        expect{ Geo::GeoLocation(3) }.to raise_error(RuntimeError)
      end

      it 'should require instantiation string to have two numbers' do
        expect{ Geo::GeoLocation('33') }.to raise_error(RuntimeError)
      end

      it 'should require latitude' do
        expect(GeoLocation.new).not_to be_valid
      end
    end
  end
end

