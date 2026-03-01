class AddHighZoneToRoundResultsAndClimbResults < ActiveRecord::Migration[8.1]
  def change
    change_table :round_results, bulk: true do |t|
      t.integer :high_zones
      t.integer :high_zone_attempts
      t.decimal :boulder_points
    end

    change_table :climb_results, bulk: true do |t|
      t.integer :high_zone_attempts
    end
  end
end
