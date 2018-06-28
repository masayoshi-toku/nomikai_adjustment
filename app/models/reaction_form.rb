class ReactionForm
  include ActiveModel::Model

  attr_accessor :user, :reaction, :answer

  validates :answer, presence: true
  validates :user, presence: true

  def create
    return false if invalid?
    create_reaction
  end

  private
    def create_reaction
      answer.each do |event_date_id, status|
        user.reactions.new(event_date_id: event_date_id, status: status)
      end
      user.save
    end
end
