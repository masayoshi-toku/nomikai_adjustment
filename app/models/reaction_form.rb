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
      ActiveRecord::Base.transaction do
        answer.each do |event_date_id, status|
          reaction = user.reactions.find_by(event_date_id: event_date_id)
          if reaction.present?
            reaction.status = status
            reaction.save!
          else
            user.reactions.new(event_date_id: event_date_id, status: status)
            user.save!
          end
        end
      end
      return true
    rescue
      return false
    end
end
