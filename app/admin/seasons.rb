ActiveAdmin.register Season do
  menu priority: 2

  permit_params :external_id, :name, :year

  index do
    selectable_column
    id_column
    column :name
    column :year
    column :external_id
    column("Competitions") { |s| s.competitions.count }
    column :created_at
    actions
  end

  filter :name
  filter :year
  filter :external_id

  show do
    attributes_table do
      row :name
      row :year
      row :external_id
      row :created_at
      row :updated_at
    end

    panel "Competitions" do
      table_for resource.competitions.order(:starts_on) do
        column(:name) { |c| link_to c.name, admin_competition_path(c) }
        column :location
        column :discipline
        column :status
        column :starts_on
        column :ends_on
      end
    end
  end
end
