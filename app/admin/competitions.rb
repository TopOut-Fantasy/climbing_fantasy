ActiveAdmin.register Competition do
  menu priority: 3

  permit_params :season_id, :external_event_id, :name, :location,
                :starts_on, :ends_on, :discipline, :status

  scope :all
  scope :upcoming
  scope :in_progress
  scope :completed

  index do
    selectable_column
    id_column
    column :name
    column :location
    column :discipline
    column :status
    column :starts_on
    column :ends_on
    column(:season) { |c| link_to c.season.name, admin_season_path(c.season) }
    actions
  end

  filter :season
  filter :name
  filter :location
  filter :discipline, as: :select, collection: Competition.disciplines
  filter :status, as: :select, collection: Competition.statuses
  filter :starts_on

  show do
    attributes_table do
      row :name
      row :location
      row :discipline
      row :status
      row :starts_on
      row :ends_on
      row(:season) { |c| link_to c.season.name, admin_season_path(c.season) }
      row :external_event_id
      row :created_at
    end

    panel "Categories" do
      table_for resource.categories do
        column(:name) { |c| link_to c.name, admin_category_path(c) }
        column :discipline
        column :gender
      end
    end
  end
end
