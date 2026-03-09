require "test_helper"

module Usac
  class ApiClientTest < ActiveSupport::TestCase
    setup do
      @client = VCR.use_cassette("usac_api_client/session") { ApiClient.new }
    end

    test "acquires session cookie on initialization" do
      VCR.use_cassette("usac_api_client/session") do
        client = ApiClient.new
        assert_instance_of(ApiClient, client)
      end
    end

    test "raises ApiError when session cookie is missing" do
      stub_request(:get, "https://usac.results.info/")
        .to_return(status: 200, headers: {}, body: "")

      assert_raises(ApiClient::ApiError) do
        VCR.turned_off { ApiClient.new }
      end
    end

    test "#get_event returns parsed event data with d_cats" do
      VCR.use_cassette("usac_api_client/get_event_448") do
        data = @client.get_event(448)

        assert_equal(448, data["id"])
        assert(data.key?("d_cats"))
        assert(data.key?("starts_at"))
        assert(data.key?("location"))

        dcat = data.fetch("d_cats").find { |cat| cat["dcat_id"] == 338 } || data.fetch("d_cats").first
        assert(dcat.key?("top_3_results"))
        assert(dcat.key?("full_results_url"))
      end
    end

    test "#live returns active category rounds" do
      VCR.use_cassette("usac_api_client/get_live") do
        data = @client.live

        assert(data.key?("live"))
        assert_kind_of(Array, data["live"])
        assert_not(data["live"].empty?)

        live_round = data["live"].first
        assert(live_round.key?("category_round_id"))
        assert(live_round.key?("event_id"))
        assert(live_round.key?("discipline_kind"))
        assert(live_round.key?("round_name"))
      end
    end

    test "#get_event_category_results returns full category standings across rounds" do
      VCR.use_cassette("usac_api_client/get_event_category_results_448_338") do
        data = @client.get_event_category_results(448, 338)

        assert(data.key?("event"))
        assert(data.key?("dcat"))
        assert(data.key?("category_rounds"))
        assert(data.key?("ranking"))
        assert_kind_of(Array, data["ranking"])
        assert_not(data["ranking"].empty?)

        athlete = data["ranking"].first
        assert(athlete.key?("rounds"))
        assert_kind_of(Array, athlete["rounds"])
        assert_not(athlete["rounds"].empty?)

        round = athlete["rounds"].first
        assert(round.key?("category_round_id"))
        assert(round.key?("round_name"))
      end
    end

    test "#get_category_round_results returns ranking data" do
      VCR.use_cassette("usac_api_client/get_category_round_results_11422") do
        data = @client.get_category_round_results(11422)

        assert_equal(11422, data["id"])
        assert_equal("Round 3", data["round"])
        assert(data.key?("ranking"))
        assert_kind_of(Array, data["ranking"])
        assert_not(data["ranking"].empty?)

        athlete = data["ranking"].first
        assert(athlete.key?("ascents"))
        assert_kind_of(Array, athlete["ascents"])
      end
    end

    test "raises ApiError on HTTP error response" do
      VCR.use_cassette("usac_api_client/error_404") do
        assert_raises(ApiClient::ApiError) do
          @client.get_event(999999)
        end
      end
    end
  end
end
