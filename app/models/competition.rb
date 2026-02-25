class Competition < ApplicationRecord
  belongs_to :season
  has_many :categories, dependent: :destroy

  enum :discipline, { boulder: 0, lead: 1, speed: 2, combined: 3, boulder_and_lead: 4 }
  enum :status, { upcoming: 0, in_progress: 1, completed: 2 }

  validates :name, presence: true
  validates :location, presence: true
  validates :starts_on, presence: true
  validates :ends_on, presence: true
  validates :discipline, presence: true
  validates :status, presence: true
end
