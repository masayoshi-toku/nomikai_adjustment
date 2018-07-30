class EventDate < ApplicationRecord
  belongs_to :event
  has_many :reactions, dependent: :destroy
  validates :event_date, presence: true, uniqueness: { scope: :event_id }
  scope :latest, -> { order(:created_at) }

  def count_status
    all_status = reactions.pluck(:status)
    @status_count = (1..3).map { |i| all_status.count(i) }
    @status_count
  end
end
