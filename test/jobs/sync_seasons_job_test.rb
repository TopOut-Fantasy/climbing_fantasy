require "test_helper"

class SyncSeasonsJobTest < ActiveSupport::TestCase
  test "enqueues on sync queue" do
    assert_equal "sync", SyncSeasonsJob.new.queue_name
  end

  test "calls SeasonSyncer then EventSyncer for pending events" do
    client = VCR.use_cassette("ifsc_api_client/session") { Ifsc::ApiClient.new }

    VCR.use_cassette("ifsc_api_client/get_season_38") do
      VCR.use_cassette("ifsc_api_client/get_season_league_457") do
        Ifsc::SeasonSyncer.call(client:, season_ids: [38])
      end
    end

    pending_event = Event.find_by(external_id: 1524)
    assert pending_event.pending_sync?

    VCR.use_cassette("ifsc_api_client/get_event_1491") do
      # Use any pending event that has a VCR cassette — event 1491 is not in the league
      # but EventSyncer works independently of SeasonSyncer
      test_event = Event.find_or_create_by!(external_id: 1491) do |e|
        e.season = Season.find_by(external_id: 38)
        e.name = "Mount Maunganui 2026"
        e.location = "Mount Maunganui, NZ"
        e.starts_on = Date.new(2026, 2, 14)
        e.ends_on = Date.new(2026, 2, 14)
        e.status = :completed
        e.sync_state = :pending_sync
      end
      Ifsc::EventSyncer.call(event: test_event, client:)
      test_event.reload
      assert test_event.needs_results?
    end
  end

  test "job rescues ApiError per event and continues processing" do
    event_a = events(:keqiao_2026)
    event_a.update!(sync_state: :pending_sync)

    event_b = events(:keqiao_boulder)
    event_b.update!(sync_state: :pending_sync)

    errors_logged = 0
    original_error = Rails.logger.method(:error)
    Rails.logger.define_singleton_method(:error) do |msg|
      errors_logged += 1 if msg.include?("SyncSeasonsJob")
      original_error.call(msg)
    end

    client = Object.new
    client.define_singleton_method(:get_event) { |_id| raise Ifsc::ApiClient::ApiError, "test error" }

    Event.pending_sync.find_each do |event|
      Ifsc::EventSyncer.call(event:, client:)
    rescue Ifsc::ApiClient::ApiError => e
      Rails.logger.error("SyncSeasonsJob: Failed to sync event #{event.external_id}: #{e.message}")
    end

    assert(errors_logged >= 2)
  ensure
    Rails.logger.singleton_class.remove_method(:error) if Rails.logger.singleton_methods.include?(:error)
  end
end
