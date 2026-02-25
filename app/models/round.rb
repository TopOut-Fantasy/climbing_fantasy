class Round < ApplicationRecord
  belongs_to :category
  has_many :round_results, dependent: :destroy

  enum :round_type, { qualification: 0, semi_final: 1, final: 2 }
  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  validates :name, presence: true
  validates :round_type, presence: true
  validates :status, presence: true
end
