# frozen_string_literal: true

require 'rails_helper'

require 'support/vcr'

RSpec.describe WeeklyForecast do
  subject(:service) { described_class.new(weather_service: meta_weather) }

  let(:meta_weather) { MetaWeather }
  let(:raleigh_woeid) { 2_478_307 }

  describe '#temperatures' do
    let(:service_call) { service.temperatures(params) }

    context 'with a valid WOEID' do
      let(:params) { { woeid: raleigh_woeid } }

      it 'returns the forecast for the week from the weather service' do
        VCR.use_cassette('MetaWeather location Raleigh') do
          expect(service_call).to have_exactly(6).items
        end
      end
    end

    context 'with an invalid WOEID' do
      let(:params) { { woeid: 0_000_000 } }

      it 'returns an empty Array' do
        VCR.use_cassette('MetaWeather location invalid') do
          expect(service_call).to be_empty
        end
      end
    end
  end
end
