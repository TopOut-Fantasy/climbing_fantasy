module Ifsc
  class RegistrationSyncer
    class << self
      def call(event:, client: ApiClient.new)
        new(event:, client:).call
      end
    end

    def initialize(event:, client:)
      @event = event
      @client = client
    end

    def call
      registrations = @client.get_event_registrations(@event.external_id)

      registrations.each { |reg| sync_registration(reg) }

      @event.update!(registrations_last_checked_at: Time.current)
    end

    private

    def sync_registration(reg)
      athlete = find_or_create_athlete(reg)

      reg["d_cats"].each do |d_cat|
        category = @event.categories.find_by(name: d_cat["name"])
        next unless category

        CategoryRegistration.find_or_create_by!(category:, athlete:)
      end
    end

    def find_or_create_athlete(reg)
      athlete = Athlete.find_or_initialize_by(external_athlete_id: reg["athlete_id"])
      athlete.update!(
        first_name: reg["firstname"],
        last_name: reg["lastname"],
        country_code: reg["country"],
        gender: map_gender(reg["gender"]),
      )
      athlete
    end

    def map_gender(value)
      case value
      when 0 then :male
      when 1 then :female
      else :other
      end
    end
  end
end
