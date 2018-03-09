# frozen_string_literal: true

require 'rails_helper'

require 'support/vcr'

RSpec.describe WeeklyForecastDecorator do
  subject(:decorator) do
    WeeklyForecast.new(weather_service: meta_weather).extend(described_class)
  end

  let(:meta_weather) { MetaWeather }

  describe '#temperatures' do
    let(:raleigh_woeid) { 2_478_307 }

    it 'contains the maximum predicted high temperature for the next 6 days' do
      VCR.use_cassette('WeeklyForecast temperatures Raleigh woeid') do
        expect(decorator.temperatures(woeid: raleigh_woeid))
          .to include('max-high' => 56.1)
      end
    end

    it 'contains the average predicted high temperature for the next 6 days' do
      VCR.use_cassette('WeeklyForecast temperatures Raleigh woeid') do
        expect(decorator.temperatures(woeid: raleigh_woeid))
          .to include('avg-high' => 47.9)
      end
    end

    it 'contains the minimum predicted high temperature for the next 6 days' do
      VCR.use_cassette('WeeklyForecast temperatures Raleigh woeid') do
        expect(decorator.temperatures(woeid: raleigh_woeid))
          .to include('min-high' => 42.76)
      end
    end

    it 'contains the maximum predicted low temperature for the next 6 days' do
      VCR.use_cassette('WeeklyForecast temperatures Raleigh woeid') do
        expect(decorator.temperatures(woeid: raleigh_woeid))
          .to include('max-low' => 38.23)
      end
    end

    it 'contains the average predicted low temperature for the next 6 days' do
      VCR.use_cassette('WeeklyForecast temperatures Raleigh woeid') do
        expect(decorator.temperatures(woeid: raleigh_woeid))
          .to include('avg-low' => 33.04)
      end
    end

    it 'contains the minimum predicted low temperature for the next 6 days' do
      VCR.use_cassette('WeeklyForecast temperatures Raleigh woeid') do
        expect(decorator.temperatures(woeid: raleigh_woeid))
          .to include('min-low' => 27.98)
      end
    end
  end
end
