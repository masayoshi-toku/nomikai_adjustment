module EventsHelper
  def set_event
    @event = Event.find_by(url_path: params[:url_path])
  end

  def convert_to_mark(event_date)
    @marks = []
    event_date.reactions.order(:id).pluck(:status).each do |status|
      case status
      when 1
        mark = '◯'
      when 2
        mark = '△'
      when 3
        mark = '×'
      end
      @marks << mark
    end
    @marks
  end
end
