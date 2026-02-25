Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule = {
      "sync_seasons" => {
        "cron" => "0 6 * * 1",
        "class" => "SyncSeasonsJob",
        "queue" => "scraping"
      },
      "sync_results" => {
        "cron" => "0 8 * * *",
        "class" => "SyncEventResultsJob",
        "queue" => "scraping"
      },
      "sync_upcoming" => {
        "cron" => "0 7 * * *",
        "class" => "SyncUpcomingEventsJob",
        "queue" => "scraping"
      }
    }
    Sidekiq::Cron::Job.load_from_hash(schedule)
  end
end
