# frozen_string_literal: true

require 'memoist'

# :nodoc:
class State < ApplicationRecord
  extend Memoist

  has_many :zipcodes, dependent: :destroy
  has_many :counties, dependent: :destroy

  validates :abbr, uniqueness: { case_sensitive: false }, presence: true
  validates :name, uniqueness: { case_sensitive: false }, presence: true

  def cities
    zipcodes.map(&:city).sort.uniq
  end
  memoize :cities
end
