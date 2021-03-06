class Event < ApplicationRecord
  belongs_to :user
  has_many :event_dates, dependent: :destroy
  accepts_nested_attributes_for :event_dates
  validates :title, presence: true, length: { maximum: 100 }, uniqueness: { scope: :user_id }
  validates :url_path, presence: true, uniqueness: true
  scope :latest, -> { order(:created_at) }

  def answerers
    if event_dates.present?
      event_dates.latest.inject(Array.new) { |answerers, event_date| answerers | event_date.reactions.latest.map { |reaction| reaction.user.name } }
    end
  end

  def owner?(check_user)
    user == check_user
  end
end
