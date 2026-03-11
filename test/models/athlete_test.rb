require "test_helper"

class AthleteTest < ActiveSupport::TestCase
  test "validates presence of first_name" do
    athlete = Athlete.new(last_name: "X", country_code: "USA", gender: :male)
    assert_not athlete.valid?
    assert_includes athlete.errors[:first_name], "can't be blank"
  end

  test "validates presence of last_name" do
    athlete = Athlete.new(first_name: "X", country_code: "USA", gender: :male)
    assert_not athlete.valid?
    assert_includes athlete.errors[:last_name], "can't be blank"
  end

  test "allows nil country_code" do
    athlete = Athlete.new(first_name: "X", last_name: "Y", gender: :male)
    assert athlete.valid?
  end

  test "validates country_code max length" do
    athlete = Athlete.new(first_name: "X", last_name: "Y", country_code: "USAA", gender: :male)
    assert_not athlete.valid?
    assert_includes athlete.errors[:country_code], "is too long (maximum is 3 characters)"
  end

  test "allows nil gender" do
    athlete = Athlete.new(first_name: "X", last_name: "Y")
    assert athlete.valid?
  end

  test "validates uniqueness of external_athlete_id scoped to source" do
    existing = athletes(:sorato_anraku)
    duplicate = Athlete.new(
      first_name: "X",
      last_name: "Y",
      source: existing.source,
      external_athlete_id: existing.external_athlete_id,
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:external_athlete_id], "has already been taken"
  end

  test "allows same external_athlete_id across different sources" do
    existing = athletes(:sorato_anraku)
    other_source = Athlete.new(
      first_name: "X",
      last_name: "Y",
      source: :usac,
      external_athlete_id: existing.external_athlete_id,
    )
    assert other_source.valid?
  end

  test "allows nil external_athlete_id" do
    athlete = Athlete.new(first_name: "X", last_name: "Y", external_athlete_id: nil)
    assert athlete.valid?
  end

  test "gender enum values" do
    assert_equal ["male", "female"], Athlete.genders.keys
  end

  test "source enum values" do
    assert_equal ["ifsc", "usac"], Athlete.sources.keys
  end

  test "has many round_results" do
    athlete = athletes(:sorato_anraku)
    assert_includes athlete.round_results, round_results(:anraku_keqiao_boulder_final)
  end

  test "athlete has expected attributes" do
    athlete = athletes(:tomoa_narasaki)
    assert_equal "Tomoa", athlete.first_name
    assert_equal "Narasaki", athlete.last_name
    assert_equal "JPN", athlete.country_code
    assert_equal "male", athlete.gender
    assert_equal "ifsc", athlete.source
  end

  test "rejects unsupported gender values" do
    assert_raises(ArgumentError) do
      Athlete.new(first_name: "X", last_name: "Y", gender: :other)
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
