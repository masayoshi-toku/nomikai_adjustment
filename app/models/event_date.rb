class EventDate < ApplicationRecord
  belongs_to :event
  validates :event_date, presence: true, uniqueness: { scope: :event_id }
end
