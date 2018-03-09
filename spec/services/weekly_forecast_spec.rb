# frozen_string_literal: true

require 'rails_helper'

require 'support/vcr'

RSpec.describe WeeklyForecast do
  subject(:service) { described_class.new(weather_service: meta_weather) }

  let(:meta_weather) { MetaWeather }
  let(:raleigh_woeid) { 2_478_307 }
  let(:raleigh_zip_code) { 27_604 }
  let(:weeks_worth) { 6 }

  describe '#temperatures' do
    let(:service_call) { service.temperatures(params) }

    context 'without a WOEID or zip code' do
      let(:params) { {} }

      it 'raises an ArgumentError with a helpful message' do
        expect { service_call }.to raise_error(ArgumentError)
          .with_message('woeid or zip_code argument required')
      end
    end

    context 'with a valid WOEID' do
      let(:params) { { woeid: raleigh_woeid } }

      it 'returns the forecast for the week from the weather service' do
        VCR.use_cassette('MetaWeather location Raleigh') do
          expect(service_call).to have_exactly(weeks_worth).items
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

    context 'with a valid zip code' do
      let(:params) { { zip_code: raleigh_zip_code } }

      before do
        allow(Zipcode)
          .to receive(:exists?)
          .with(code: raleigh_zip_code)
          .and_return(true)
      end

      it 'returns the forecast for the week from the weather service' do
        VCR.use_cassette('WeeklyForecast temperatures Raleigh zipcode') do
          expect(service_call).to have_exactly(weeks_worth).items
        end
      end
    end

    context 'with an invalid zip code' do
      let(:params) { { zip_code: unused_zip_code } }
      let(:unused_zip_code) { 26_901 }

      before do
        allow(Zipcode)
          .to receive(:exists?)
          .with(code: unused_zip_code)
          .and_return(false)
      end

      it 'returns an empty Array' do
        VCR.use_cassette('WeeklyForecast temperatures invalid zipcode') do
          expect(service_call).to be_empty
        end
      end
    end

    context 'when the geocoder is over its query limit' do
      let(:params) { { zip_code: raleigh_zip_code } }

      it 'returns an empty Array' do
        VCR.use_cassette('WeeklyForecast temperatures geocoder rate limited') do
          expect(service_call).to be_empty
        end
      end
    end
  end
end
