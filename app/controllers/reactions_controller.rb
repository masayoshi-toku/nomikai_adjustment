class ReactionsController < ApplicationController
  before_action :set_event, :logged_in?

  def new
    initialize_reaction_form_object
  end

  def edit
    initialize_reaction_form_object
  end

  def create
    @reaction_form = ReactionForm.new(reaction_params.merge(user: current_user))
    if @reaction_form.create
      redirect_to event_url(@event.url_path), notice: '出席の登録に成功しました。'
    else
      redirect_to new_event_reactions_url(@event.url_path), notice: '出席の登録に失敗しました。'
    end
  end

  def update
    @reaction_form = ReactionForm.new(reaction_params.merge(user: current_user))
    if @reaction_form.update_or_create
      redirect_to event_url(@event.url_path), notice: '出席の更新に成功しました。'
    else
      redirect_to edit_event_reactions_path(@event.url_path), notice: '出席の更新に失敗しました。'
    end
  end

  def destroy
    if @event
      event_reactions = current_user.reactions.where(event_date_id: @event.event_dates.ids)
      if Reaction.destroy(event_reactions.ids)
        redirect_to event_url(@event.url_path), notice: '出席の削除に成功しました。'
      else
        redirect_to event_url(@event.url_path), notice: '出席の削除に失敗しました。'
      end
    else
      redirect_to root_path, notice: 'イベントが存在しません。'
    end
  end

  private
    def initialize_reaction_form_object
      if @event
        @reaction_form = ReactionForm.new
      else
        redirect_to root_url, notice: 'イベントが存在しません。'
      end
    end

    def set_event
      @event = Event.find_by(url_path: params[:event_url_path])
    end

    def reaction_params
      params.require(:reaction_form).permit(answer: {})
    end
end
