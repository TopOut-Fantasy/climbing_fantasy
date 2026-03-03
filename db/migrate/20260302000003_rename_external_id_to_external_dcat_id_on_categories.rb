class RenameExternalIdToExternalDcatIdOnCategories < ActiveRecord::Migration[8.0]
  def change
    rename_column :categories, :external_id, :external_dcat_id
  end
end
