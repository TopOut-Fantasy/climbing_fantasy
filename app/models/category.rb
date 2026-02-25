class Category < ApplicationRecord
  belongs_to :competition
  has_many :rounds, dependent: :destroy

  enum :discipline, { boulder: 0, lead: 1, speed: 2, combined: 3, boulder_and_lead: 4 }
  enum :gender, { male: 0, female: 1 }

  validates :name, presence: true
  validates :discipline, presence: true
  validates :gender, presence: true
  validates :external_category_id, uniqueness: { scope: :competition_id }, allow_nil: true
end
