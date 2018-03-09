# frozen_string_literal: true

# :nodoc:
class API < Grape::API
  format :json

  namespace :weather do
    namespace :forecasts do
      route_param :id do
        get do
          forecast = WeeklyForecast.new(weather_service: MetaWeather)
                                   .extend(WeeklyForecastDecorator)
                                   .temperatures(woeid: params[:id])

          unless forecast
            status 400
            return ''
          end

          forecast
        end
      end
    end
  end
end
