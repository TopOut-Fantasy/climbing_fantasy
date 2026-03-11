require "test_helper"

class RoundTest < ActiveSupport::TestCase
  test "validates presence of name" do
    round = Round.new(category: categories(:keqiao_boulder_men), round_type: :qualification, status: :pending)
    round.name = nil
    assert_not round.valid?
    assert_includes round.errors[:name], "can't be blank"
  end

  test "round_type enum values" do
    assert_equal ["qualification", "round_of_16", "quarter_final", "semi_final", "small_final", "final"], Round.round_types.keys
  end

  test "status enum values" do
    assert_equal ["pending", "in_progress", "completed"], Round.statuses.keys
  end

  test "belongs to category" do
    round = rounds(:keqiao_boulder_men_qual)
    assert_equal categories(:keqiao_boulder_men), round.category
  end

  test "has many round_results" do
    round = rounds(:keqiao_boulder_men_final)
    assert_includes round.round_results, round_results(:anraku_keqiao_boulder_final)
    assert_includes round.round_results, round_results(:lee_keqiao_boulder_final)
  end

  test "has many routes" do
    round = rounds(:keqiao_boulder_men_final)
    assert_includes round.routes, routes(:keqiao_men_final_p1)
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
