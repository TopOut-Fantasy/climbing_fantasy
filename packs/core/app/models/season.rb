class Season < ApplicationRecord
  has_many :events, dependent: :destroy

  enum :source, { ifsc: 0, usac: 1 }

  validates :name, presence: true
  validates :year, presence: true, numericality: { only_integer: true }

  class << self
    def ransackable_attributes(_auth_object = nil)
      ["name", "year", "external_id", "source"]
    end
  end
end

# == Schema Information
#
# Table name: seasons
#
#  id          :bigint           not null, primary key
#  name        :string
#  source      :integer          default("ifsc"), not null
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :integer
#
# Indexes
#
#  index_seasons_on_source_and_external_id  (source,external_id) UNIQUE
#
