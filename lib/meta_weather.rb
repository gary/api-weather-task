# frozen_string_literal: true

# A thin wrapper around the MetaWeather data aggregator.
#
# @see https://www.metaweather.com/about/
module MetaWeather
  Location = Struct.new(:distance, :type, :coordinates, :name, :woeid)
  Forecast = Struct.new(:current, :date, :high, :low)

  API = 'https://www.metaweather.com/api'
  private_constant :API

  module_function

  # @api public
  # @param woeid [Integer] the Where On Earth ID of the desired location
  # @return [Array<Forecast>] the forecast for the next 5 days
  # @return [Array] empty set if +woeid+ was invalid
  # @see https://en.wikipedia.org/wiki/WOEID
  def location(woeid:)
    endpoint_url = "/location/#{woeid}/"

    response = RestClient.get(API + endpoint_url)

    JSON.parse(response.body)['consolidated_weather']
        .each_with_object([]) do |weather, weekly_forecast|
      values = weather.fetch_values('the_temp', 'applicable_date',
                                    'max_temp', 'min_temp')

      weekly_forecast << Forecast.new(*values)
    end
  rescue RestClient::ExceptionWithResponse
    []
  end

  # @api public
  # @param lat [Float] latitude of the location to lookup
  # @param long [Float] longitude of the location to lookup
  # @return [Location] the location
  def location_search(lat:, long:)
    endpoint_url = "/location/search/?lattlong=#{lat},#{long}"

    response    = RestClient.get(API + endpoint_url)
    location    = JSON.parse(response.body).first

    coordinates = location['latt_long'].split(',').map(&:to_f)
    Location.new(location['distance'], location['location_type'], coordinates,
                 location['title'], location['woeid'])
  end
end
