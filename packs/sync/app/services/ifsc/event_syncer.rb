module Ifsc
  class EventSyncer
    class << self
      def call(event:, client: ApiClient.new)
        new(event:, client:).call
      end
    end

    def initialize(event:, client:)
      @event = event
      @client = client
    end

    def call
      data = @client.get_event(@event.external_id)

      data["d_cats"].each { |d_cat| sync_category(d_cat) }

      @event.update!(
        sync_state: :synced,
        info_sheet_url: data["infosheet_url"],
      )
    end

    private

    def sync_category(d_cat)
      category = Category.find_or_initialize_by(event: @event, external_id: d_cat["category_id"])
      category.update!(
        name: d_cat["dcat_name"],
        discipline: map_discipline(d_cat["discipline_kind"]),
        gender: parse_gender(d_cat["category_name"]),
      )

      d_cat["category_rounds"].each { |round_data| sync_round(category, round_data) }
    end

    def sync_round(category, round_data)
      round = Round.find_or_initialize_by(category:, external_round_id: round_data["category_round_id"])
      round.update!(
        name: round_data["name"],
        round_type: map_round_type(round_data["name"]),
        status: map_round_status(round_data["status"]),
      )

      round_data["routes"]&.each { |route| sync_climb(round, route) }
    end

    def sync_climb(round, route)
      group_label = route["name"]&.downcase
      group_label = nil if ["a", "b"].exclude?(group_label)

      Climb.find_or_create_by!(
        round:,
        number: route["id"],
      ) do |climb|
        climb.group_label = group_label
      end
    end

    def map_discipline(kind)
      {
        "speed" => :speed,
        "boulder" => :boulder,
        "lead" => :lead,
        "combined" => :combined,
        "boulder&lead" => :boulder_and_lead,
      }.fetch(kind.to_s.downcase, :combined)
    end

    def parse_gender(category_name)
      case category_name.to_s
      when /\bMen\b/ then :male
      when /\bWomen\b/ then :female
      else :mixed
      end
    end

    def map_round_type(name)
      case name.to_s
      when /qualification/i then :qualification
      when /round of 16/i then :round_of_16
      when /quarter.?final/i then :quarter_final
      when /semi.?final/i then :semi_final
      when /small.?final/i then :small_final
      when /final/i then :final
      else :qualification
      end
    end

    def map_round_status(status)
      case status.to_s
      when "finished" then :completed
      when "active" then :in_progress
      else :pending
      end
    end
  end
end
