class ReactionForm
  include ActiveModel::Model

  attr_accessor :user, :answer

  validates :answer, presence: true
  validates :user, presence: true

  def create
    return false if invalid?
    create_reaction
  end

  def update_or_create
    return false if invalid?
    update_or_create_reaction
  end

  private
    def create_reaction
      answer.each do |event_date_id, status|
        user.reactions.new(event_date_id: event_date_id, status: status)
      end
      user.save
    end

    def update_or_create_reaction
      @new_reaction_flag = 0
      answer.each do |event_date_id, status|
        reaction = user.reactions.find_by(event_date_id: event_date_id)
        if reaction.present?
          return false unless reaction.update(status: status)
        else
          @new_reaction_flag = 1
          user.reactions.new(event_date_id: event_date_id, status: status)
        end
      end

      if @new_reaction_flag == 1
        user.save
      end

      return true
    end
end
