class EventsController < ApplicationController
  before_action :set_event, except: [:index, :new, :create]

  def index
    @events = Event.all
  end

  def show
    exist_or_redirect(@event)
  end

  def new
    @event_form = EventForm.new(event: Event.new)
  end

  def edit
    exist_or_redirect(@event)
  end

  def create
    @event_form = EventForm.new(event_params.merge({ user: current_user }))

    if @event_form.event = @event_form.create
      redirect_to @event_form.event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def update
    if @event&.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @event&.destroy
      redirect_to events_url, notice: 'Event was successfully destroyed.'
    else
      render :index
    end
  end

  private
    def set_event
      @event = Event.find_by(id: params[:id])
    end

    def event_params
      params.require(:event_form).permit(:title, :event_dates_text)
    end

    def exist_or_redirect(event)
      unless event
        redirect_to events_url
      end
    end
end
