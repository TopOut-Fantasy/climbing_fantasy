require "test_helper"

class CsvImporter::AthleteImporterTest < ActiveSupport::TestCase
  test "imports athletes from CSV" do
    csv_path = Rails.root.join("test/fixtures/files/athletes_import.csv")

    # Remove fixtures that would conflict
    Athlete.where(external_athlete_id: [8677, 6280, 5765]).delete_all

    assert_difference "Athlete.count", 3 do
      CsvImporter::AthleteImporter.import(csv_path)
    end
  end

  test "skips existing athletes by external_id" do
    csv_path = Rails.root.join("test/fixtures/files/athletes_import.csv")

    # First import
    Athlete.where(external_athlete_id: [8677, 6280, 5765]).delete_all
    CsvImporter::AthleteImporter.import(csv_path)

    # Second import — no new records
    assert_no_difference "Athlete.count" do
      CsvImporter::AthleteImporter.import(csv_path)
    end
  end

  test "maps gender correctly" do
    csv_path = Rails.root.join("test/fixtures/files/athletes_import.csv")
    Athlete.where(external_athlete_id: [8677, 6280, 5765]).delete_all
    CsvImporter::AthleteImporter.import(csv_path)

    fujii = Athlete.find_by(external_athlete_id: 8677)
    assert_equal "male", fujii.gender

    garnbret = Athlete.find_by(external_athlete_id: 5765)
    assert_equal "female", garnbret.gender
  end
end
