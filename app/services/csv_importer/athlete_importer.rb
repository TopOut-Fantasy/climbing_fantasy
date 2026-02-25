require "csv"

module CsvImporter
  class AthleteImporter
    VALID_GENDERS = %w[male female].freeze

    def self.import(file_path)
      CSV.foreach(file_path, headers: true) do |row|
        athlete = Athlete.find_or_initialize_by(external_athlete_id: row["athlete_id"].to_i)

        athlete.first_name = row["firstname"]
        athlete.last_name = row["lastname"]
        athlete.country_code = (row["country"].presence || "UNK").first(3)
        athlete.gender = parse_gender(row["gender"])
        athlete.height = parse_float(row["height"])
        athlete.arm_span = parse_float(row["arm_span"])
        athlete.birthday = parse_date(row["birthday"])

        athlete.save!
      end
    end

    def self.parse_gender(value)
      VALID_GENDERS.include?(value&.downcase) ? value.downcase : :other
    end

    def self.parse_float(value)
      return nil if value.blank?
      f = value.to_f
      f > 0 ? f : nil
    end

    def self.parse_date(value)
      return nil if value.blank?
      Date.parse(value)
    rescue Date::Error
      nil
    end

    private_class_method :parse_gender, :parse_float, :parse_date
  end
end
