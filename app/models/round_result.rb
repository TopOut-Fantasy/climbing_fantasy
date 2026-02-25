class RoundResult < ApplicationRecord
  belongs_to :round
  belongs_to :athlete

  validates :rank, numericality: { only_integer: true }, allow_nil: true
  validates :tops, numericality: { only_integer: true }, allow_nil: true
  validates :zones, numericality: { only_integer: true }, allow_nil: true
  validates :top_attempts, numericality: { only_integer: true }, allow_nil: true
  validates :zone_attempts, numericality: { only_integer: true }, allow_nil: true
  validates :athlete_id, uniqueness: { scope: :round_id }
end
