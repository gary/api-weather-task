# frozen_string_literal: true

require 'memoist'

# :nodoc:
class County < ApplicationRecord
  extend Memoist

  belongs_to :state
  has_many :zipcodes, dependent: :destroy

  validates :name,
            uniqueness: { scope: :state_id, case_sensitive: false },
            presence: true

  scope :without_state, -> { where('state_id IS NULL') }

  def self.without_zipcodes
    joins('LEFT JOIN zipcodes ON zipcodes.county_id = counties.id')
      .where('zipcodes.county_id IS NULL')
  end

  def cities
    zipcodes.map(&:city).sort.uniq
  end
  memoize :cities
end
