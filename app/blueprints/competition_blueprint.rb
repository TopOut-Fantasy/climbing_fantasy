class CompetitionBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :location, :starts_on, :ends_on, :discipline, :status,
         :season_id, :external_event_id

  view :extended do
    association :season, blueprint: SeasonBlueprint
    association :categories, blueprint: CategoryBlueprint
  end
end
