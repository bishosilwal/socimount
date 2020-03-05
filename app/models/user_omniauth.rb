class UserOmniauth < ApplicationRecord
  belongs_to :user
  enum status: { inactive: 0, active: 1 }
end
