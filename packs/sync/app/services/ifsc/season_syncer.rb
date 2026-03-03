module Ifsc
  class SeasonSyncer
    CURRENT_SEASON_IDS = [37, 38].freeze

    class << self
      def call(client: ApiClient.new, season_ids: CURRENT_SEASON_IDS)
        new(client:, season_ids:).call
      end
    end

    def initialize(client:, season_ids: CURRENT_SEASON_IDS)
      @client = client
      @season_ids = season_ids
    end

    def call
      @season_ids.each { |id| sync_season(id) }
    end

    private

    def sync_season(season_id)
      data = @client.get_season(season_id)

      season = Season.find_or_initialize_by(external_id: season_id)
      season.update!(
        name: data["name"],
        year: data["name"].to_i,
      )

      data["events"].each { |event_data| sync_event(season, event_data) }
    end

    def sync_event(season, event_data)
      event = Event.find_or_initialize_by(external_id: event_data["event_id"])
      event.assign_attributes(
        season:,
        name: event_data["event"],
        location: event_data["location"],
        starts_on: Date.parse(event_data["local_start_date"]),
        ends_on: Date.parse(event_data["local_end_date"]),
        status: infer_status(event_data["starts_at"], event_data["ends_at"]),
      )
      event.sync_state = :pending_sync if event.new_record?
      event.save!
    end

    def infer_status(starts_at, ends_at)
      now = Time.current
      start_time = Time.zone.parse(starts_at)
      end_time = Time.zone.parse(ends_at)

      if now < start_time
        :upcoming
      elsif now > end_time
        :completed
      else
        :in_progress
      end
    end
  end
end
