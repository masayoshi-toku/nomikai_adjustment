class EventsController < ApplicationController
  before_action :logged_in?, except: [:index]
  before_action :set_event, :exist_or_redirect, except: [:index, :new, :create]
  before_action :correct_user?, only: [:edit, :update, :destroy]

  def index
    @events = Event.all
  end

  def show
  end

  def new
    @event_form = EventForm.new(event: Event.new)
  end

  def edit
    @event_form = EventForm.new(event: @event)
  end

  def create
    @event_form = EventForm.new(event_params.merge({ user: current_user }))
    if @event_form.valid?
      @event_form.event = @event_form.create
      redirect_to event_path(@event_form.event.url_path), notice: 'Event was successfully created.'
    else
      @event_form.event = Event.new
      render :new
    end
  end

  def update
    @event_form = EventForm.new(edit_event_params.merge({ user: current_user, event: @event }))
    if @event_form.update
      redirect_to event_path(@event_form.event.url_path), notice: 'イベントの更新に成功しました。'
    else
      redirect_to edit_event_url(@event.url_path), notice: 'イベントの更新に失敗しました。'
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
    def event_params
      params.require(:event_form).permit(:title, :event_dates_text)
    end

    def edit_event_params
      params.require(:event_form).permit(:title, :event_dates_text, deletable_event_dates: {})
    end

    def set_event
      @event = Event.find_by(url_path: params[:url_path])
    end

    def exist_or_redirect
      unless @event.present?
        redirect_to events_url
      end
    end

    def correct_user?
      unless current_user == @event.user
        redirect_to events_url, notice: 'イベントを編集する権限がありません。' and return
      end
    end
end
