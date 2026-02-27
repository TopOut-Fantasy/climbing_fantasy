class Round < ApplicationRecord
  belongs_to :category
  has_many :round_results, dependent: :destroy

  enum :round_type, { qualification: 0, semi_final: 1, final: 2 }
  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  validates :name, presence: true
  validates :round_type, presence: true
  validates :status, presence: true
end

# == Schema Information
#
# Table name: rounds
#
#  id                :bigint           not null, primary key
#  name              :string           not null
#  round_type        :integer          not null
#  status            :integer          default("pending"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  category_id       :bigint           not null
#  external_round_id :integer
#
# Indexes
#
#  index_rounds_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
