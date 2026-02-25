class SyncUpcomingEventsJob < ApplicationJob
  queue_as :scraping

  def perform(adapter: :net_http, stubs: nil)
    client = Ifsc::Client.new(adapter: adapter, stubs: stubs)

    Competition.upcoming.find_each do |competition|
      next unless competition.external_event_id

      event_data = client.fetch_event_results(competition.external_event_id)
      Ifsc::ResultSyncer.sync_categories(competition, event_data)
    rescue Ifsc::Client::ApiError => e
      Rails.logger.error "Failed to sync upcoming event #{competition.id}: #{e.message}"
    end
  end
end
