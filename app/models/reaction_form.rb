class ReactionForm
  include ActiveModel::Model

  attr_accessor :user, :answer

  validates :answer, presence: true
  validates :user, presence: true

  def create
    return false if invalid?
    create_reaction
  end

  def update
    return false if invalid?
    update_reaction
  end

  private
    def create_reaction
      answer.each do |event_date_id, status|
        user.reactions.new(event_date_id: event_date_id, status: status)
      end
      user.save
    end

    def update_reaction
      answer.each do |event_date_id, status|
        reaction = user.reactions.find_by(event_date_id: event_date_id)
        unless reaction.update(status: status)
          return false
        end
      end
    end
end
