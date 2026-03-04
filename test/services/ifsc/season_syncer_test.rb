require "test_helper"

module Ifsc
  class SeasonSyncerTest < ActiveSupport::TestCase
    setup do
      @client = VCR.use_cassette("ifsc_api_client/session") { ApiClient.new }
    end

    test "syncs season from API data" do
      VCR.use_cassette("ifsc_api_client/get_season_38") do
        VCR.use_cassette("ifsc_api_client/get_season_league_457") do
          SeasonSyncer.call(client: @client, season_ids: [38])
        end
      end

      season = Season.find_by(external_id: 38)
      assert_not_nil season
      assert_equal "2026", season.name
      assert_equal 2026, season.year
    end

    test "creates only World Cup league events" do
      VCR.use_cassette("ifsc_api_client/get_season_38") do
        VCR.use_cassette("ifsc_api_client/get_season_league_457") do
          SeasonSyncer.call(client: @client, season_ids: [38])
        end
      end

      season = Season.find_by(external_id: 38)

      # All 13 league events should exist
      league_event_ids = [1524, 1525, 1478, 1479, 1480, 1482, 1483, 1484, 1487, 1526, 1527, 1488, 1489]
      league_event_ids.each do |eid|
        assert season.events.exists?(external_id: eid), "Expected event #{eid} to exist"
      end

      event = season.events.find_by(external_id: 1524)
      assert_equal "World Climbing Series Keqiao 2026", event.name
      assert_includes ["upcoming", "in_progress", "completed"], event.status
    end

    test "new events get pending_sync state" do
      VCR.use_cassette("ifsc_api_client/get_season_38") do
        VCR.use_cassette("ifsc_api_client/get_season_league_457") do
          SeasonSyncer.call(client: @client, season_ids: [38])
        end
      end

      season = Season.find_by(external_id: 38)
      new_event = season.events.find_by(external_id: 1524)
      assert_not_nil new_event
      assert new_event.pending_sync?
    end

    test "parses location from event name when API location is missing for new events" do
      VCR.use_cassette("ifsc_api_client/get_season_38") do
        VCR.use_cassette("ifsc_api_client/get_season_league_457") do
          SeasonSyncer.call(client: @client, season_ids: [38])
        end
      end

      event = Event.find_by(external_id: 1525)
      assert_not_nil event
      assert_equal "Wujiang", event.location
    end

    test "does not overwrite existing location on subsequent season sync" do
      VCR.use_cassette("ifsc_api_client/get_season_38") do
        VCR.use_cassette("ifsc_api_client/get_season_league_457") do
          SeasonSyncer.call(client: @client, season_ids: [38])
        end
      end

      event = Event.find_by(external_id: 1525)
      event.update!(location: "Wujiang, China")

      VCR.use_cassette("ifsc_api_client/get_season_38", allow_playback_repeats: true) do
        VCR.use_cassette("ifsc_api_client/get_season_league_457", allow_playback_repeats: true) do
          SeasonSyncer.call(client: @client, season_ids: [38])
        end
      end

      assert_equal "Wujiang, China", event.reload.location
    end

    test "is idempotent" do
      2.times do
        VCR.use_cassette("ifsc_api_client/get_season_38", allow_playback_repeats: true) do
          VCR.use_cassette("ifsc_api_client/get_season_league_457", allow_playback_repeats: true) do
            SeasonSyncer.call(client: @client, season_ids: [38])
          end
        end
      end

      assert_equal 1, Season.where(external_id: 38).count
    end

    test "no matching league logs warning and creates no events" do
      stub_data = { "name" => "2026", "leagues" => [{ "name" => "Youth", "url" => "/api/v1/season_leagues/999" }], "events" => [] }
      client = Object.new
      client.define_singleton_method(:get_season) { |_id| stub_data }

      event_count_before = Event.count
      SeasonSyncer.call(client:, season_ids: [38])

      season = Season.find_by(external_id: 38)
      assert_not_nil season
      assert_equal 0, Event.count - event_count_before
    end
  end
end
