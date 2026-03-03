require "test_helper"

module Ifsc
  class RegistrationSyncerTest < ActiveSupport::TestCase
    setup do
      @client = VCR.use_cassette("ifsc_api_client/session") { ApiClient.new }
      @season = Season.find_or_create_by!(external_id: 38) do |s|
        s.name = "2026"
        s.year = 2026
      end
      @event = Event.find_or_create_by!(external_id: 1491) do |e|
        e.season = @season
        e.name = "Mount Maunganui 2026"
        e.location = "Mount Maunganui, NZ"
        e.starts_on = Date.new(2026, 2, 14)
        e.ends_on = Date.new(2026, 2, 14)
        e.status = :completed
        e.sync_state = :synced
      end

      # Sync event first so categories exist
      VCR.use_cassette("ifsc_api_client/get_event_1491") do
        EventSyncer.call(event: @event, client: @client)
      end
    end

    test "creates athletes from registration data" do
      VCR.use_cassette("ifsc_api_client/get_event_registrations_1491") do
        RegistrationSyncer.call(event: @event, client: @client)
      end

      athlete = Athlete.find_by(external_athlete_id: 16642)
      assert_not_nil athlete
      assert_equal "Christian", athlete.first_name
      assert_equal "WILLIAMS", athlete.last_name
      assert_equal "AUS", athlete.country_code
      assert_equal "male", athlete.gender
    end

    test "creates category registrations" do
      VCR.use_cassette("ifsc_api_client/get_event_registrations_1491") do
        RegistrationSyncer.call(event: @event, client: @client)
      end

      speed_men = @event.categories.find_by(external_id: 6978)
      assert speed_men.category_registrations.any?
    end

    test "updates registrations_last_checked_at" do
      VCR.use_cassette("ifsc_api_client/get_event_registrations_1491") do
        RegistrationSyncer.call(event: @event, client: @client)
      end

      @event.reload
      assert_not_nil @event.registrations_last_checked_at
    end

    test "is idempotent" do
      2.times do
        VCR.use_cassette("ifsc_api_client/get_event_registrations_1491") do
          RegistrationSyncer.call(event: @event, client: @client)
        end
      end

      athlete = Athlete.find_by(external_athlete_id: 16642)
      assert_equal 1, Athlete.where(external_athlete_id: 16642).count
      assert_equal 1, athlete.category_registrations.joins(:category).where(categories: { event_id: @event.id }).count
    end
  end
end
