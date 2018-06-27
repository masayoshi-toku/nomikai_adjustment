module EventsHelper
  def set_event
    @event = Event.find_by(url_path: params[:url_path])
  end

  def answerers(event)
    @answerers = []
    first_event_date = event.event_dates.first
    first_event_date_reactions = Reaction.where(event_date_id: first_event_date.id)

    first_event_date_reactions.each do |first_event_date_reaction|
      @answerers << first_event_date_reaction.user.name
    end

    @answerers
  end

  def reactions(event)
    @reactions = []
    event.event_dates.order('created_at ASC').each_with_index do |event_date, index|
      @reactions[index] = {}
      @reactions[index][:event_date] = event_date.event_date
      @reactions[index][:marks] = []
      @available = 0
      @undecided = 0
      @unavailable = 0

      event_date.reactions.pluck(:status).each do |status|
        case status
        when 1
          mark = '◯'
          @available += 1
        when 2
          mark = '△'
          @undecided += 1
        when 3
          mark = '×'
          @unavailable += 1
        end

        @reactions[index][:marks] << mark
      end

      @reactions[index][:counts] = [ @available, @undecided, @unavailable ]
    end
    @reactions
  end
end
