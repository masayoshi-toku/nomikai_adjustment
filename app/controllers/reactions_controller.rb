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
    @reaction = Reaction.new(reaction_params)

    if @reaction.save
      redirect_to event_url(@reaction.event), notice: '回答しました。'
    else
      render :new
    end
  end

  def update
    if @reaction&.update(reaction_params)
      redirect_to event_url(@reaction.event), notice: 'Reaction was successfully updated.'
    else
      render :edit
    end
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
      params.require(:reaction).permit(:user_id, :event_date_id, :status)
    end

    def exist_or_redirect(reaction)
      unless reaction
        redirect_back(fallback_location: root_path, notice: 'この回答は存在しません。')
      end
    end
end
