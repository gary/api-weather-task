# frozen_string_literal: true

# A thin wrapper around the MetaWeather data aggregator.
#
# @see https://www.metaweather.com/about/
module MetaWeather
  Location = Struct.new(:distance, :type, :coordinates, :name, :woeid)

  API = 'https://www.metaweather.com/api'
  private_constant :API

  module_function

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
