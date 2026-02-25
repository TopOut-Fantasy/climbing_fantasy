require "test_helper"

class SyncUpcomingEventsJobTest < ActiveJob::TestCase
  test "enqueues on scraping queue" do
    assert_enqueued_with(job: SyncUpcomingEventsJob, queue: "scraping") do
      SyncUpcomingEventsJob.perform_later
    end
  end
end
