class RoundResult < ApplicationRecord
  belongs_to :round
  belongs_to :athlete

  validates :rank, numericality: { only_integer: true }, allow_nil: true
  validates :tops, numericality: { only_integer: true }, allow_nil: true
  validates :zones, numericality: { only_integer: true }, allow_nil: true
  validates :top_attempts, numericality: { only_integer: true }, allow_nil: true
  validates :zone_attempts, numericality: { only_integer: true }, allow_nil: true
  validates :athlete_id, uniqueness: { scope: :round_id }
end

# == Schema Information
#
# Table name: round_results
#
#  id                     :bigint           not null, primary key
#  lead_height            :decimal(, )
#  lead_plus              :boolean          default(FALSE)
#  rank                   :integer
#  score_raw              :string
#  speed_eliminated_stage :string
#  speed_time             :decimal(, )
#  top_attempts           :integer
#  tops                   :integer
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
