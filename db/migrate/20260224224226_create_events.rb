class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :season, null: false, foreign_key: true
      t.integer :source, default: 0, null: false
      t.integer :external_id
      t.string :name, null: false
      t.string :location, null: false
      t.string :country_code, limit: 3
      t.date :starts_on, null: false
      t.date :ends_on, null: false
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :timezone_name
      t.integer :status, default: 0, null: false
      t.integer :sync_state, default: 0, null: false
      t.datetime :results_synced_at
      t.datetime :registrations_last_checked_at

      t.timestamps
    end

    add_index :events, [:source, :external_id], unique: true
    add_index :events, :sync_state
  end
end
