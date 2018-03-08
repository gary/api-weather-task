# frozen_string_literal: true

require 'rails_helper'

require 'support/vcr'

RSpec.describe MetaWeather do
  subject(:api_wrapper) { described_class }

  let(:raleigh_woeid) { 2_478_307 }

  describe '.location_search' do
    let(:api_call) { api_wrapper.location_search(params) }

    context 'with a valid latitude and longitude' do
      let(:raleigh_lat)  { 35.8150476 }
      let(:raleigh_long) { -78.57744079999999 }
      let(:params) { { lat: raleigh_lat, long: raleigh_long } }

      # rubocop:disable RSpec/ExampleLength
      it 'returns location information for the coordinates' do
        VCR.use_cassette('MetaWeather location search Raleigh') do
          expect(api_call).to have_attributes(
            coordinates: [35.785511, -78.642670],
            distance: 6733,
            name: 'Raleigh',
            type: 'City',
            woeid: 2_478_307
          )
        end
      end
      # rubocop:enable RSpec/ExampleLength
    end
  end

  describe '.location' do
    let(:api_call) { api_wrapper.location(params) }

    # rubocop:disable RSpec/ExampleLength
    context 'with a valid WOEID' do
      let(:params) { { woeid: raleigh_woeid } }

      it 'returns the forecast data for the next week' do
        VCR.use_cassette('MetaWeather location Raleigh') do
          expect(api_call).to match(
            [
              an_object_responding_to(:current, :date, :high, :low),
              an_object_responding_to(:current, :date, :high, :low),
              an_object_responding_to(:current, :date, :high, :low),
              an_object_responding_to(:current, :date, :high, :low),
              an_object_responding_to(:current, :date, :high, :low),
              an_object_responding_to(:current, :date, :high, :low)
            ]
          )
        end
      end
      # rubocop:enable RSpec/ExampleLength
    end

    context 'with an invalid WOEID' do
      let(:params) { { woeid: 0_000_000 } }

      it 'returns an empty Array' do
        VCR.use_cassette('MetaWeather location invalid') do
          expect(api_call).to match_array([])
        end
      end
    end
  end
end
