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

  test "validates presence of country_code" do
    athlete = Athlete.new(first_name: "X", last_name: "Y", gender: :male)
    assert_not athlete.valid?
    assert_includes athlete.errors[:country_code], "can't be blank"
  end

  test "validates country_code max length" do
    athlete = Athlete.new(first_name: "X", last_name: "Y", country_code: "USAA", gender: :male)
    assert_not athlete.valid?
    assert_includes athlete.errors[:country_code], "is too long (maximum is 3 characters)"
  end

  test "validates uniqueness of external_athlete_id" do
    existing = athletes(:janja_garnbret)
    duplicate = Athlete.new(first_name: "X", last_name: "Y", country_code: "USA", gender: :female, external_athlete_id: existing.external_athlete_id)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:external_athlete_id], "has already been taken"
  end

  test "allows nil external_athlete_id" do
    athlete = Athlete.new(first_name: "X", last_name: "Y", country_code: "USA", gender: :male, external_athlete_id: nil)
    assert athlete.valid?
  end

  test "gender enum values" do
    assert_equal %w[male female non_binary other], Athlete.genders.keys
  end

  test "has many round_results" do
    athlete = athletes(:kokoro_fujii)
    assert_includes athlete.round_results, round_results(:fujii_innsbruck_final)
  end

  test "athlete has expected attributes" do
    athlete = athletes(:janja_garnbret)
    assert_equal "Janja", athlete.first_name
    assert_equal "Garnbret", athlete.last_name
    assert_equal "SLO", athlete.country_code
    assert_equal "female", athlete.gender
  end

  test "height arm_span and birthday are optional" do
    athlete = Athlete.new(first_name: "X", last_name: "Y", country_code: "USA", gender: :male)
    assert athlete.valid?
    assert_nil athlete.height
    assert_nil athlete.arm_span
    assert_nil athlete.birthday
  end

  test "height must be greater than zero when present" do
    athlete = Athlete.new(first_name: "X", last_name: "Y", country_code: "USA", gender: :male, height: -1)
    assert_not athlete.valid?
    assert_includes athlete.errors[:height], "must be greater than 0"

    athlete.height = 0
    assert_not athlete.valid?

    athlete.height = 170.0
    assert athlete.valid?
  end

  test "arm_span must be greater than zero when present" do
    athlete = Athlete.new(first_name: "X", last_name: "Y", country_code: "USA", gender: :male, arm_span: -5)
    assert_not athlete.valid?
    assert_includes athlete.errors[:arm_span], "must be greater than 0"

    athlete.arm_span = 175.0
    assert athlete.valid?
  end

  test "non_binary and other gender values" do
    nb = Athlete.new(first_name: "X", last_name: "Y", country_code: "USA", gender: :non_binary)
    assert nb.valid?
    assert_equal "non_binary", nb.gender

    other = Athlete.new(first_name: "X", last_name: "Y", country_code: "USA", gender: :other)
    assert other.valid?
    assert_equal "other", other.gender
  end

  test "fixture athlete has height arm_span and birthday" do
    athlete = athletes(:janja_garnbret)
    assert_equal 164.0, athlete.height
    assert_equal 166.0, athlete.arm_span
    assert_equal Date.parse("1999-03-12"), athlete.birthday
  end
end
