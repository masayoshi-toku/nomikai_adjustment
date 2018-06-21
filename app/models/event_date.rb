class EventDate < ApplicationRecord
  belongs_to :event
  has_many :reactions
  validates :event_date, presence: true, uniqueness: { scope: :event_id }
end
