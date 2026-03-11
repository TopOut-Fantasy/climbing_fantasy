class RoundResult < ApplicationRecord
  belongs_to :round
  belongs_to :athlete
  has_many :ascents, dependent: :destroy

  enum :group_label, { a: "A", b: "B" }, prefix: :group

  validates :rank, numericality: { only_integer: true }, allow_nil: true
  validates :tops, numericality: { only_integer: true }, allow_nil: true
  validates :zones, numericality: { only_integer: true }, allow_nil: true
  validates :top_attempts, numericality: { only_integer: true }, allow_nil: true
  validates :zone_attempts, numericality: { only_integer: true }, allow_nil: true
  validates :high_zones, numericality: { only_integer: true }, allow_nil: true
  validates :high_zone_attempts, numericality: { only_integer: true }, allow_nil: true
  validates :boulder_points, numericality: true, allow_nil: true
  validates :athlete_id, uniqueness: { scope: :round_id }

  class << self
    def ransackable_attributes(_auth_object = nil)
      ["rank", "score_raw", "round_id", "athlete_id"]
    end

    def ransackable_associations(_auth_object = nil)
      ["round", "athlete", "ascents"]
    end
  end
end

# == Schema Information
#
# Table name: round_results
#
#  id                     :bigint           not null, primary key
#  active                 :boolean
#  bib                    :string
#  boulder_points         :decimal(, )
#  group_label            :string
#  group_rank             :integer
#  high_zone_attempts     :integer
#  high_zones             :integer
#  lead_height            :decimal(, )
#  lead_plus              :boolean          default(FALSE)
#  rank                   :integer
#  score_raw              :string
#  speed_eliminated_stage :string
#  speed_time             :decimal(, )
#  start_order            :integer
#  starting_group         :string
#  top_attempts           :integer
#  tops                   :integer
#  under_appeal           :boolean
#  zone_attempts          :integer
#  zones                  :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  athlete_id             :bigint           not null
#  round_id               :bigint           not null
#
# Indexes
#
#  index_round_results_on_athlete_id               (athlete_id)
#  index_round_results_on_round_id                 (round_id)
#  index_round_results_on_round_id_and_athlete_id  (round_id,athlete_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (athlete_id => athletes.id)
#  fk_rails_...  (round_id => rounds.id)
#
