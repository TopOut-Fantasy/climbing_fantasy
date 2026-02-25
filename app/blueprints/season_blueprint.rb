class SeasonBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :year, :external_id

  view :extended do
    association :competitions, blueprint: CompetitionBlueprint
  end
end
