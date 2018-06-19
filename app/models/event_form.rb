class EventForm
  include ActiveModel::Model

  attr_reader :current_user
  attr_accessor :event, :title, :event_dates_text

  validates :title, presence: true, length: { maximum: 100 }
  validates :event_dates_text, presence: true

  def initialize(current_user = nil, attributes = {})
    @current_user = current_user
    super(attributes)
  end

  def create
    if invalid? || @current_user.nil?
      return false
    end
    self.event = @current_user.events.create(nested_params)
  end

  private
    def nested_params
      { title: title, url_path: url_path, event_dates_attributes: event_dates }
    end

    def url_path
      SecureRandom.urlsafe_base64
    end

    def event_dates
      dates = []
      event_dates_text.split("\r\n").each do |event_date|
        dates << { event_date: event_date }
      end
      return dates
    end
end
