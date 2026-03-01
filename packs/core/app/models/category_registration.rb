class CategoryRegistration < ApplicationRecord
  belongs_to :category
  belongs_to :athlete

  validates :athlete_id, uniqueness: { scope: :category_id }
end
