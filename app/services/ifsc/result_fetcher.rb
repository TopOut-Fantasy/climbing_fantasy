module Ifsc
  class ResultFetcher
    def initialize(client:)
      @client = client
    end

    def call(category)
      competition = category.competition
      return unless competition.external_event_id && category.external_category_id

      data = @client.fetch_category_results(competition.external_event_id, category.external_category_id)
      ResultSyncer.sync_results(category, data)
    end
  end
end
