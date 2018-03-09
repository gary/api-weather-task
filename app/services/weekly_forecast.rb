# frozen_string_literal: true

# :nodoc:
class WeeklyForecast
  attr_reader :weather_service
  private :weather_service

  # @param weather_service [#location,#location_search]
  def initialize(weather_service:)
    @weather_service = weather_service
  end

  # @api public
  # @see (see Metaweather.location)
  def temperatures(woeid: nil, zip_code: nil)
    raise missing_required_argument if woeid.blank? && zip_code.blank?

    woeid ||= begin
      return [] unless Zipcode.exists?(code: zip_code)
      return [] unless (coordinates = geocode(zip_code))

      location = weather_service.location_search(lat: coordinates.latitude,
                                                 long: coordinates.longitude)
      location.woeid
    end

    weather_service.location(woeid: woeid)
  end

  private

  def geocode(zip_code)
    result = Geocoder.search(zip_code)

    result.empty? ? nil : result.first
  end

  def missing_required_argument
    ArgumentError.new('woeid or zip_code argument required')
  end
end
