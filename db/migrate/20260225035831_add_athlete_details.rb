class AddAthleteDetails < ActiveRecord::Migration[8.1]
  def change
    add_column :athletes, :height, :float
    add_column :athletes, :arm_span, :float
    add_column :athletes, :birthday, :date
  end
end
