class AddHtmlSyncFieldsToAthletes < ActiveRecord::Migration[8.1]
  def change
    add_column :athletes, :photo_url, :string
    add_column :athletes, :hometown, :string
    add_column :athletes, :federation, :string
    add_column :athletes, :active_since_year, :integer
    add_column :athletes, :participations_count, :integer
    add_column :athletes, :age_last_seen, :integer
    add_column :athletes, :age_last_seen_at, :date
    add_column :athletes, :birth_year_estimate, :integer
    add_column :athletes, :birth_year_source, :string
    add_column :athletes, :profile_last_synced_at, :datetime
  end
end
