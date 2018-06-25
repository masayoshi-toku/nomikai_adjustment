module EventsHelper
  def set_event
    @event = Event.find_by(url_path: params[:url_path])
  end
end
