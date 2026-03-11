class Athlete < ApplicationRecord
  has_many :round_results, dependent: :destroy
  has_many :category_registrations, dependent: :destroy
  has_many :rounds, through: :round_results
  has_many :categories, through: :category_registrations
  has_many :ascents, through: :round_results

  enum :source, { ifsc: 0, usac: 1 }
  enum :gender, { male: 0, female: 1 }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :country_code, length: { maximum: 3 }, allow_nil: true
  validates :external_athlete_id, uniqueness: { scope: :source }, allow_nil: true

  class << self
    def ransackable_attributes(_auth_object = nil)
      [
        "first_name",
        "last_name",
        "country_code",
        "gender",
        "source",
        "external_athlete_id",
      ]
    end
  end
end

# == Schema Information
#
# Table name: athletes
#
#  id                  :bigint           not null, primary key
#  country_code        :string(3)
#  federation          :string
#  first_name          :string           not null
#  flag_url            :string
#  gender              :integer
#  last_name           :string           not null
#  photo_url           :string
#  source              :integer          default("ifsc"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  external_athlete_id :integer
#  federation_id       :integer
#
# Indexes
#
#  index_athletes_on_source_and_external_athlete_id  (source,external_athlete_id) UNIQUE
#
