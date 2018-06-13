class Event < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }, uniqueness: { scope: [:user_id, :title]  }
end
