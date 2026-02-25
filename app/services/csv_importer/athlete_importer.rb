require "csv"

module CsvImporter
  class AthleteImporter
    def self.import(file_path)
      CSV.foreach(file_path, headers: true) do |row|
        Athlete.find_or_create_by!(external_athlete_id: row["athlete_id"].to_i) do |a|
          a.first_name = row["first_name"]
          a.last_name = row["last_name"]
          a.country_code = row["country"]
          a.gender = row["gender"] == "F" ? :female : :male
        end
      end
    end
  end
end
