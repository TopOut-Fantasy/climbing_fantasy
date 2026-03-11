class Route < ApplicationRecord
  belongs_to :round
  has_many :ascents, dependent: :destroy

  enum :group_label, { a: "A", b: "B" }, prefix: :group

  validates :external_route_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
end

# == Schema Information
#
# Table name: routes
#
#  id                :bigint           not null, primary key
#  group_label       :string
#  route_name        :string
#  route_order       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  external_route_id :integer          not null
#  round_id          :bigint           not null
#
# Indexes
#
#  index_routes_on_round_id                                   (round_id)
#  index_routes_on_round_id_and_group_label_and_ext_route_id  (round_id,group_label,external_route_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (round_id => rounds.id)
#
