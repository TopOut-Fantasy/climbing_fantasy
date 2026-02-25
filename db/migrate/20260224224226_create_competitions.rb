class CreateCompetitions < ActiveRecord::Migration[8.1]
  def change
    create_table :competitions do |t|
      t.references :season, null: false, foreign_key: true
      t.integer :external_event_id
      t.string :name, null: false
      t.string :location, null: false
      t.date :starts_on, null: false
      t.date :ends_on, null: false
      t.integer :discipline, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
