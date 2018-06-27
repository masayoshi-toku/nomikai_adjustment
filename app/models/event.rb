class Event < ApplicationRecord
  belongs_to :user
  has_many :event_dates, dependent: :destroy
  accepts_nested_attributes_for :event_dates
  validates :title, presence: true, length: { maximum: 100 }, uniqueness: { scope: :user_id }
  validates :url_path, presence: true, uniqueness: true

  def answerers
    first_event_date = event_dates.first
    @answerers = first_event_date.reactions.order(:id).map { |reaction| reaction.user.name }
    @answerers
  end
end
