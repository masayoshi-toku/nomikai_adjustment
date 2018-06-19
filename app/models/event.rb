class Event < ApplicationRecord
  belongs_to :user
  has_many :event_dates, dependent: :destroy
  validates :title, presence: true, length: { maximum: 100 }, uniqueness: { scope: :user_id }
  validates :url_path, presence: true, uniqueness: true
end
