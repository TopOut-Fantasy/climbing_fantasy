class Season < ApplicationRecord
  has_many :competitions, dependent: :destroy

  validates :name, presence: true
  validates :year, presence: true, numericality: { only_integer: true }
end
