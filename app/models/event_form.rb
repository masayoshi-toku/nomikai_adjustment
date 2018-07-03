class EventForm
  include ActiveModel::Model

  attr_accessor :user, :event, :title, :event_dates_text, :deletable_event_dates

  validates :title, presence: true, length: { maximum: 100 }
  validates :event_dates_text, :user, presence: true

  def create
    return false if invalid?
    user.events.create(nested_params)
  end

  def update
    update_reaction
  end

  private
    def update_reaction
      ActiveRecord::Base.transaction do
        title_update
        delete_event_dates
        update_or_create_event_dates
        return true
      rescue ActiveRecord::RecordNotDestroyed, ActiveRecord::RecordInvalid
        return false
      end
    end

    def title_update
      if title.present?
        event.update!(title: title)
      end
    end

    def delete_event_dates
      if deletable_event_dates.present?
        checked_deletable_event_dates = deletable_event_dates.delete_if { |key, value| value == '0' }
        if checked_deletable_event_dates.present?
          event.event_dates.where(id: checked_deletable_event_dates.keys).each(&:destroy!)
        end
      end
    end

    def update_or_create_event_dates
      if event_dates_text.present?
        event_dates.each do |event_date|
          event.event_dates.new(event_date)
        end
        event.save!
      end
    end

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
