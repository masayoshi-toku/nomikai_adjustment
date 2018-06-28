class ReactionsController < ApplicationController
  before_action :set_reaction, only: [:edit, :update, :destroy]
  before_action :set_event, only: [:new, :create]

  def new
    if @event
      @reaction_form = ReactionForm.new(reaction: Reaction.new)
    else
      redirect_to root_url
    end
  end

  def edit
    exist_or_redirect(@reaction)
  end

  def create
    @reaction_form = ReactionForm.new(reaction_params.merge(user: current_user))
    if @reaction_form.create
      redirect_to event_url(@event.url_path), notice: '出席の登録に成功しました。'
    else
      redirect_to new_event_reaction_url(@event.url_path), notice: '出席の登録に失敗しました。'
    end
  end

  def destroy
    if @reaction&.destroy
      redirect_to event_url(@reaction.event), notice: '回答を削除しました。'
    else
      redirect_to root_url, notice: '回答を削除できませんでした'
    end
  end

  private
    def set_reaction
      @reaction = Reaction.find_by(id: params[:id])
    end

    def set_event
      @event = Event.find_by(url_path: params[:event_url_path])
    end

    def reaction_params
      params.require(:reaction_form).permit(answer: {})
    end

    def exist_or_redirect(reaction)
      unless reaction
        redirect_back(fallback_location: root_path, notice: 'この回答は存在しません。')
      end
    end
end
