class Event < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }, uniqueness: { scope: [:user_id, :title] }
  validates :url_path, presence: true, uniqueness: true
  belongs_to :user
end
