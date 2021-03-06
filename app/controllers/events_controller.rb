class EventsController < ApplicationController
  before_action :logged_in?
  before_action :set_event, :exist_or_redirect, except: [:index, :new, :create]
  before_action :event_owner?, only: [:edit, :update, :destroy]

  def index
    @user_events = current_user.events.latest
  end

  def show
    @event_dates = @event.event_dates.date_latest
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
      redirect_to event_path(@event_form.event.url_path), notice: 'イベントの作成に成功しました。'
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
    if @event.destroy
      redirect_to events_url, notice: 'イベントを削除しました。'
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

    def event_owner?
      redirect_to events_url, notice: 'イベントを編集する権限がありません。' and return unless @event.owner?(current_user)
    end
end
