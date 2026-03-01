class RenameFederationToClubOnAthletes < ActiveRecord::Migration[8.1]
  def change
    rename_column :athletes, :federation, :club
  end
end
