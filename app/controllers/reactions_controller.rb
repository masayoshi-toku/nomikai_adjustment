class ReactionsController < ApplicationController
  before_action :set_reaction, only: [:edit, :update, :destroy]
  before_action :set_event, only: [:new, :create]

  def new
    if @event
      @reaction_form = ReactionForm.new(reaction: Reaction.new)
    else
      redirect_back(fallback_location: root_path, notice: 'イベントページが存在しません。')
    end
  end

  def edit
    exist_or_redirect(@reaction)
  end

  def create
    @reaction_form = ReactionForm.new(reaction_params.merge(user: current_user))
    @reaction_form.create
    redirect_to event_url(@reaction_form.event_url_path)
  rescue => e
    redirect_to new_reaction_url(url_path: reaction_params[:event_url_path]), notice: '出席を登録する際にエラーが発生しました。'
  end

  def destroy
    if @reaction&.destroy
      redirect_to event_url(@reaction.event), notice: 'Reaction was successfully destroyed.'
    else
      redirect_to root_url
    end
  end

  private
    def set_reaction
      @reaction = Reaction.find_by(id: params[:id])
    end

    def reaction_params
      params.require(:reaction_form).permit(:event_url_path, status: {})
    end

    def exist_or_redirect(reaction)
      unless reaction
        redirect_back(fallback_location: root_path, notice: 'この回答は存在しません。')
      end
    end
end
