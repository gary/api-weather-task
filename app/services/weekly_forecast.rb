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
  def temperatures(woeid:)
    weather_service.location(woeid: woeid)
  end
end
