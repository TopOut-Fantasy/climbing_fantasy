class Round < ApplicationRecord
  belongs_to :category
  has_many :round_results, dependent: :destroy
  has_many :athletes, through: :round_results
  has_many :routes, dependent: :destroy

  enum :round_type, {
    qualification: "qualification",
    round_of_16: "round_of_16",
    quarter_final: "quarter_final",
    semi_final: "semi_final",
    small_final: "small_final",
    final: "final",
  }
  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  validates :name, presence: true
  validates :round_type, presence: true
  validates :status, presence: true

  class << self
    def ransackable_attributes(_auth_object = nil)
      ["name", "round_type", "status", "format", "external_round_id", "category_id"]
    end

    def ransackable_associations(_auth_object = nil)
      ["category", "round_results", "athletes", "routes"]
    end
  end
end

# == Schema Information
#
# Table name: rounds
#
#  id                :bigint           not null, primary key
#  format            :string
#  name              :string           not null
#  round_type        :string           not null
#  status            :integer          default("pending"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  category_id       :bigint           not null
#  external_round_id :integer
#
# Indexes
#
#  index_rounds_on_category_id        (category_id)
#  index_rounds_on_external_round_id  (external_round_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
