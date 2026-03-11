class Category < ApplicationRecord
  belongs_to :event
  has_many :rounds, dependent: :destroy
  has_many :category_registrations, dependent: :destroy
  has_many :athletes, through: :category_registrations
  has_many :round_results, through: :rounds

  enum :discipline, { boulder: 0, lead: 1, speed: 2 }
  enum :gender, { male: 0, female: 1 }
  enum :category_status, { not_started: 0, active: 1, finished: 2 }

  validates :name, presence: true
  validates :discipline, presence: true
  validates :gender, presence: true
  validates :external_dcat_id, uniqueness: { scope: :event_id }, allow_nil: true

  class << self
    def ransackable_attributes(_auth_object = nil)
      ["name", "discipline", "gender", "category_status", "external_dcat_id", "event_id"]
    end

    def ransackable_associations(_auth_object = nil)
      ["event", "rounds", "category_registrations", "athletes", "round_results"]
    end
  end
end

# == Schema Information
#
# Table name: categories
#
#  id               :bigint           not null, primary key
#  category_status  :integer
#  discipline       :integer          not null
#  gender           :integer          not null
#  name             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  event_id         :bigint           not null
#  external_dcat_id :integer
#
# Indexes
#
#  index_categories_on_event_id                       (event_id)
#  index_categories_on_event_id_and_external_dcat_id  (event_id,external_dcat_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
