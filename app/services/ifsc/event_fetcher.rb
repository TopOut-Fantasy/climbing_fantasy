module Ifsc
  class EventFetcher
    def initialize(client:)
      @client = client
    end

    def call(competition)
      return unless competition.external_event_id

      data = @client.fetch_event_results(competition.external_event_id)
      ResultSyncer.sync_categories(competition, data)
    end
  end
end
