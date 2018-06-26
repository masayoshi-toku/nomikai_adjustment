class EventForm
  include ActiveModel::Model

  attr_accessor :user, :event, :title, :event_dates_text

  validates :title, presence: true, length: { maximum: 100 }
  validates :event_dates_text, :user, presence: true

  def create
    return false if invalid?
    user.events.create(nested_params)
  end

  private
    def nested_params
      { title: title, url_path: url_path, event_dates_attributes: event_dates }
    end

    def url_path
      SecureRandom.urlsafe_base64
    end

    def event_dates
      event_dates_text.split(/[\r\n]+|\r+|\n+/).uniq.inject(Array.new) {|array, value| array.push({ event_date: value })}
    end
end
