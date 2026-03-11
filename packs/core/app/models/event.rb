class Event < ApplicationRecord
  belongs_to :season
  has_many :categories, dependent: :destroy
  has_many :category_registrations, through: :categories
  has_many :athletes, through: :category_registrations
  has_many :rounds, through: :categories

  enum :source, { ifsc: 0, usac: 1 }
  enum :status, { upcoming: 0, in_progress: 1, completed: 2 }
  enum :sync_state, { pending_sync: 0, synced: 1, needs_results: 2 }

  validates :name, presence: true
  validates :location, presence: true
  validates :starts_on, presence: true
  validates :ends_on, presence: true
  validates :status, presence: true

  class << self
    def ransackable_attributes(_auth_object = nil)
      [
        "name",
        "location",
        "country_code",
        "status",
        "sync_state",
        "starts_on",
        "ends_on",
        "starts_at",
        "ends_at",
        "timezone_name",
        "results_synced_at",
        "season_id",
        "source",
      ]
    end

    def ransackable_associations(_auth_object = nil)
      ["season", "categories", "category_registrations", "athletes", "rounds"]
    end
  end
end

# == Schema Information
#
# Table name: events
#
#  id                            :bigint           not null, primary key
#  country_code                  :string(3)
#  ends_at                       :datetime
#  ends_on                       :date             not null
#  location                      :string           not null
#  name                          :string           not null
#  registrations_last_checked_at :datetime
#  results_synced_at             :datetime
#  source                        :integer          default("ifsc"), not null
#  starts_at                     :datetime
#  starts_on                     :date             not null
#  status                        :integer          default("upcoming"), not null
#  sync_state                    :integer          default("pending_sync"), not null
#  timezone_name                 :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  external_id                   :integer
#  season_id                     :bigint           not null
#
# Indexes
#
#  index_events_on_season_id               (season_id)
#  index_events_on_source_and_external_id  (source,external_id) UNIQUE
#  index_events_on_sync_state              (sync_state)
#
# Foreign Keys
#
#  fk_rails_...  (season_id => seasons.id)
#
