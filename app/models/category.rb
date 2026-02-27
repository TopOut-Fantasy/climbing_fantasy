class Category < ApplicationRecord
  belongs_to :competition
  has_many :rounds, dependent: :destroy

  enum :discipline, { boulder: 0, lead: 1, speed: 2, combined: 3, boulder_and_lead: 4 }
  enum :gender, { male: 0, female: 1, non_binary: 2, other: 3, mixed: 4 }

  validates :name, presence: true
  validates :discipline, presence: true
  validates :gender, presence: true
  validates :external_category_id, uniqueness: { scope: :competition_id }, allow_nil: true
end

# == Schema Information
#
# Table name: categories
#
#  id                   :bigint           not null, primary key
#  discipline           :integer          not null
#  gender               :integer          not null
#  name                 :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  competition_id       :bigint           not null
#  external_category_id :integer
#
# Indexes
#
#  index_categories_on_competition_id                           (competition_id)
#  index_categories_on_competition_id_and_external_category_id  (competition_id,external_category_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (competition_id => competitions.id)
#
