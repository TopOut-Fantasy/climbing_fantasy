class CreateSeasons < ActiveRecord::Migration[8.1]
  def change
    create_table :seasons do |t|
      t.integer :external_id
      t.string :name
      t.integer :year

      t.timestamps
    end
  end
end
