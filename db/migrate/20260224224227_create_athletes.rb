class CreateAthletes < ActiveRecord::Migration[8.1]
  def change
    create_table :athletes do |t|
      t.integer :source, default: 0, null: false
      t.integer :external_athlete_id
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :country_code, limit: 3
      t.integer :gender
      t.string :photo_url
      t.string :flag_url
      t.string :federation
      t.integer :federation_id

      t.timestamps
    end

    add_index :athletes, [:source, :external_athlete_id], unique: true
  end
end
