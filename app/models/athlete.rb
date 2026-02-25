class Athlete < ApplicationRecord
  has_many :round_results, dependent: :destroy

  enum :gender, { male: 0, female: 1 }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :country_code, presence: true, length: { maximum: 3 }
  validates :gender, presence: true
  validates :external_athlete_id, uniqueness: true, allow_nil: true
end
