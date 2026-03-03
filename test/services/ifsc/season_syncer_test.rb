require "test_helper"

module Ifsc
  class SeasonSyncerTest < ActiveSupport::TestCase
    setup do
      @client = VCR.use_cassette("ifsc_api_client/session") { ApiClient.new }
    end

    test "syncs season from API data" do
      VCR.use_cassette("ifsc_api_client/get_season_38") do
        SeasonSyncer.call(client: @client, season_ids: [38])
      end

      season = Season.find_by(external_id: 38)
      assert_not_nil season
      assert_equal "2026", season.name
      assert_equal 2026, season.year
    end

    test "creates events for season" do
      VCR.use_cassette("ifsc_api_client/get_season_38") do
        SeasonSyncer.call(client: @client, season_ids: [38])
      end

      season = Season.find_by(external_id: 38)
      assert season.events.any?

      event = season.events.find_by(external_id: 1491)
      assert_not_nil event
      assert_equal "World Climbing Oceania Championship Mount Maunganui 2026", event.name
      assert_includes ["upcoming", "in_progress", "completed"], event.status
    end

    test "new events get pending_sync state" do
      VCR.use_cassette("ifsc_api_client/get_season_38") do
        SeasonSyncer.call(client: @client, season_ids: [38])
      end

      season = Season.find_by(external_id: 38)
      new_event = season.events.find_by(external_id: 1491)
      assert_not_nil new_event
      assert new_event.pending_sync?
    end

    test "is idempotent" do
      2.times do
        VCR.use_cassette("ifsc_api_client/get_season_38", allow_playback_repeats: true) do
          SeasonSyncer.call(client: @client, season_ids: [38])
        end
      end

      assert_equal 1, Season.where(external_id: 38).count
    end
  end
end
