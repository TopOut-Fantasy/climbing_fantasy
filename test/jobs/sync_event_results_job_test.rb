require "test_helper"

class SyncEventResultsJobTest < ActiveJob::TestCase
  test "enqueues on scraping queue" do
    assert_enqueued_with(job: SyncEventResultsJob, queue: "scraping") do
      SyncEventResultsJob.perform_later
    end
  end
end
