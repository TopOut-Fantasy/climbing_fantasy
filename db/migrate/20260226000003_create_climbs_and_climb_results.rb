class CreateClimbsAndClimbResults < ActiveRecord::Migration[8.1]
  def change
    create_table :routes do |t|
      t.references :round, null: false, foreign_key: true
      t.integer :external_route_id, null: false
      t.string :route_name
      t.integer :route_order
      t.string :group_label

      t.timestamps
    end

    add_index :routes, [:round_id, :group_label, :external_route_id], unique: true,
      name: "index_routes_on_round_id_and_group_label_and_ext_route_id"

    create_table :ascents do |t|
      t.references :round_result, null: false, foreign_key: true
      t.references :route, null: false, foreign_key: true
      t.string :ascent_status
      t.datetime :modified_at

      # Boulder fields
      t.boolean :top
      t.integer :top_tries
      t.boolean :zone
      t.integer :zone_tries
      t.boolean :low_zone
      t.integer :low_zone_tries
      t.decimal :points

      # Lead fields
      t.decimal :height, precision: 5, scale: 2
      t.boolean :plus
      t.integer :rank
      t.string :score_raw

      # Speed fields
      t.integer :time_ms
      t.boolean :dnf
      t.boolean :dns

      t.timestamps
    end

    add_index :ascents, [:round_result_id, :route_id], unique: true
  end
end
