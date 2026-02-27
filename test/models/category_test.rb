require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "validates presence of name" do
    cat = Category.new(competition: competitions(:innsbruck_boulder), discipline: :boulder, gender: :male)
    cat.name = nil
    assert_not cat.valid?
    assert_includes cat.errors[:name], "can't be blank"
  end

  test "discipline enum values" do
    assert_equal %w[boulder lead speed combined boulder_and_lead], Category.disciplines.keys
  end

  test "gender enum values" do
    assert_equal %w[male female non_binary other mixed], Category.genders.keys
  end

  test "belongs to competition" do
    cat = categories(:innsbruck_boulder_men)
    assert_equal competitions(:innsbruck_boulder), cat.competition
  end

  test "has many rounds" do
    cat = categories(:innsbruck_boulder_men)
    assert_includes cat.rounds, rounds(:innsbruck_boulder_men_qual)
    assert_includes cat.rounds, rounds(:innsbruck_boulder_men_final)
  end

  test "unique external_category_id within competition" do
    existing = categories(:innsbruck_boulder_men)
    duplicate = Category.new(
      competition: existing.competition,
      external_category_id: existing.external_category_id,
      name: "Duplicate",
      discipline: :boulder,
      gender: :male
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:external_category_id], "has already been taken"
  end
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
