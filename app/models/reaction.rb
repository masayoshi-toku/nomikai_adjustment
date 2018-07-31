class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :event_date
  delegate :event, to: :event_date
  validates :status, presence: true, inclusion: { in: 1..3 }
  scope :latest, -> { order(:created_at) }
end
