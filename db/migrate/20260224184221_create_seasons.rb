class CreateSeasons < ActiveRecord::Migration[8.1]
  def change
    create_table :seasons do |t|
      t.integer :source, default: 0, null: false
      t.integer :external_id
      t.string :name
      t.integer :year

      t.timestamps
    end

    add_index :seasons, [:source, :external_id], unique: true
  end
end
