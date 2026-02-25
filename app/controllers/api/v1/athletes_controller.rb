module Api
  module V1
    class AthletesController < BaseController
      def index
        scope = Athlete.all
        if params[:q].present?
          query = "%#{params[:q]}%"
          scope = scope.where("first_name ILIKE :q OR last_name ILIKE :q", q: query)
        end
        scope = scope.where(country_code: params[:country]) if params[:country].present?

        pagy, athletes = pagy(scope.order(:last_name, :first_name), limit: params.fetch(:per_page, 25).to_i)
        render json: {
          data: AthleteBlueprint.render_as_hash(athletes),
          meta: pagination_meta(pagy)
        }
      end

      def show
        athlete = Athlete.find(params[:id])
        render json: {
          data: AthleteBlueprint.render_as_hash(athlete, view: :extended)
        }
      end
    end
  end
end
