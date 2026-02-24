class AdminUser < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  enum :role, { viewer: 0, admin: 1, super_admin: 2 }

  validates :role, presence: true
end
