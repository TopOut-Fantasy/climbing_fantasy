ActiveAdmin.register(Athlete) do
  menu priority: 4

  permit_params :external_athlete_id,
    :first_name,
    :last_name,
    :country_code,
    :gender

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :country_code
    column :gender
    column :external_athlete_id
    column("Results") { |a| a.round_results.count }
    actions
  end

  filter :first_name
  filter :last_name
  filter :country_code
  filter :gender, as: :select, collection: Athlete.genders
  filter :external_athlete_id

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :country_code
      row :gender
      row :external_athlete_id
      row :created_at
    end

    panel "Recent Results" do
      table_for resource.round_results.includes(round: { category: :event }).order(created_at: :desc).limit(20) do
        column("Event") { |result| result.round.category.event.name }
        column("Round") { |r| r.round.name }
        column :rank
        column :score_raw
      end
    end
  end
end
