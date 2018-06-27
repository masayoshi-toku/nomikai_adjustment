class EventDate < ApplicationRecord
  belongs_to :event
  has_many :reactions
  validates :event_date, presence: true, uniqueness: { scope: :event_id }

  def count_status
    all_status = reactions.pluck(:status)
    @status_count = (1..3).map { |i| all_status.count(i) }
    @status_count
  end
end
