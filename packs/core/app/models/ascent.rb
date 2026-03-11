class Ascent < ApplicationRecord
  belongs_to :round_result
  belongs_to :route

  validates :round_result_id, uniqueness: { scope: :route_id }
end

# == Schema Information
#
# Table name: ascents
#
#  id              :bigint           not null, primary key
#  ascent_status   :string
#  dnf             :boolean
#  dns             :boolean
#  height          :decimal(5, 2)
#  low_zone        :boolean
#  low_zone_tries  :integer
#  modified_at     :datetime
#  plus            :boolean
#  points          :decimal(, )
#  rank            :integer
#  score_raw       :string
#  time_ms         :integer
#  top             :boolean
#  top_tries       :integer
#  zone            :boolean
#  zone_tries      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  round_result_id :bigint           not null
#  route_id        :bigint           not null
#
# Indexes
#
#  index_ascents_on_round_result_id               (round_result_id)
#  index_ascents_on_round_result_id_and_route_id  (round_result_id,route_id) UNIQUE
#  index_ascents_on_route_id                      (route_id)
#
# Foreign Keys
#
#  fk_rails_...  (round_result_id => round_results.id)
#  fk_rails_...  (route_id => routes.id)
#
