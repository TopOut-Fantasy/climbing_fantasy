require "test_helper"

class SyncSeasonsJobTest < ActiveJob::TestCase
  test "enqueues on scraping queue" do
    assert_enqueued_with(job: SyncSeasonsJob, queue: "scraping") do
      SyncSeasonsJob.perform_later
    end
  end

  test "calls client and syncer" do
    stub_response = File.read(Rails.root.join("test/fixtures/files/ifsc_seasons_response.json"))
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("/results-api.php?api=index") { [200, { "Content-Type" => "application/json" }, stub_response] }
    end

    assert_difference "Season.count" do
      SyncSeasonsJob.perform_now(adapter: :test, stubs: stubs)
    end
  end
end
