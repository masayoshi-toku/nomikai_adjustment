class EventsController < ApplicationController
  before_action :set_event, except: [:index, :new, :create]

  def index
    @events = Event.all
  end

  def show
    exist_or_redirect(@event)
  end

  def new
    @event = Event.new
  end

  def edit
    exist_or_redirect(@event)
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
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
      params.require(:event).permit(:user_id, :title, :url_path)
    end

    def exist_or_redirect(event)
      unless event
        redirect_to events_url
      end
    end
end
