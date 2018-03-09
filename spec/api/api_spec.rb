# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API do
  describe 'GET /weather/forecasts/:id' do
    let(:raleigh_woeid) { 2_478_307 }

    context "when the 'Authorization' header is missing a Bearer token" do
      xit 'returns a 401' do
        VCR.use_cassette('MetaWeather location Raleigh') do
          get "/weather/forecasts/#{raleigh_woeid}"

          expect(response).to have_http_status(401)
        end
      end
    end

    context 'when :id is a valid WOEID' do
      it 'returns a summary of the forecast the next 6 days' do
        VCR.use_cassette('MetaWeather location Raleigh') do
          get "/weather/forecasts/#{raleigh_woeid}"

          expect(response_body).to include(
            'max-high' => 52.92, 'avg-high' => 49.54, 'min-high' => 45.06,
            'max-low' => 39.1, 'avg-low' => 34.2, 'min-low' => 29.1
          )
        end
      end
    end

    context 'when :id is an invalid WOEID' do
      it 'returns a 400' do
        VCR.use_cassette('WeeklyForecast temperature invalid woeid') do
          get '/weather/forecasts/0000000'

          expect(response).to have_http_status(400)
        end
      end

      it 'does not return a response payload' do
        VCR.use_cassette('WeeklyForecast temperature invalid woeid') do
          get '/weather/forecasts/0000000'

          expect(response_body).to be_blank
        end
      end
    end

    def response_body
      JSON.parse(response.body)
    end
  end
end
