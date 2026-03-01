class CreateCategoryRegistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :category_registrations do |t|
      t.references :category, null: false, foreign_key: true
      t.references :athlete, null: false, foreign_key: true
      t.datetime :registered_at_source
      t.string :status

      t.timestamps
    end

    add_index :category_registrations,
      [:category_id, :athlete_id],
      unique: true,
      name: "index_category_registrations_category_athlete_unique"
  end
end
