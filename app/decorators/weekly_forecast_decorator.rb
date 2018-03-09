# frozen_string_literal: true

# :nodoc:
module WeeklyForecastDecorator
  # @api public
  # @param (see WeeklyForecast#temperatures)
  def temperatures(woeid: nil, zip_code: nil)
    forecast = super(woeid: woeid, zip_code: zip_code)

    summary(forecast).transform_values do |celcius|
      celcius.convert_to('tempF').scalar.to_f.truncate(2)
    end
  end

  private

  def average_high(forecast)
    Unit.new("#{forecast.sum(&:high) / forecast.size} tempC")
  end

  def average_low(forecast)
    Unit.new("#{forecast.sum(&:low) / forecast.size} tempC")
  end

  def max_high(forecast)
    Unit.new("#{forecast.map(&:high).max} tempC")
  end

  def max_low(forecast)
    Unit.new("#{forecast.map(&:low).max} tempC")
  end

  def min_high(forecast)
    Unit.new("#{forecast.map(&:high).min} tempC")
  end

  def min_low(forecast)
    Unit.new("#{forecast.map(&:low).min} tempC")
  end

  def summary(forecast)
    {

      'max-high' => max_high(forecast),
      'avg-high' => average_high(forecast),
      'min-high' => min_high(forecast),
      'max-low'  => max_low(forecast),
      'avg-low'  => average_low(forecast),
      'min-low'  => min_low(forecast)
    }
  end
end
