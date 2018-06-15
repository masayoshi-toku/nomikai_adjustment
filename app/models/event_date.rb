class EventDate < ApplicationRecord
  validates :event_date, presence: true, uniqueness: { scope: :event_id }
  belongs_to :event
end
