require "test_helper"

class AscentTest < ActiveSupport::TestCase
  test "topped ascent has top true" do
    assert ascents(:anraku_keqiao_p1).top
  end

  test "non-topped ascent has top false" do
    assert_not ascents(:thomas_nsw_p2).top
  end

  test "zoned ascent has zone true" do
    assert ascents(:anraku_keqiao_p1).zone
  end

  test "non-zoned ascent has zone false" do
    assert_not ascents(:thomas_nsw_p2).zone
  end

  test "belongs to round_result" do
    ascent = ascents(:anraku_keqiao_p1)
    assert_equal round_results(:anraku_keqiao_boulder_final), ascent.round_result
  end

  test "belongs to route" do
    ascent = ascents(:anraku_keqiao_p1)
    assert_equal routes(:keqiao_men_final_p1), ascent.route
  end
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
