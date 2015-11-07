require 'spec_helper'

require 'geo_location'

module Geo
  describe GeoLocation do
    let(:verve) { Geo::GeoLocation('33.1243208, -117.32582479999996') }

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
  end
end

