class ReactionForm
  include ActiveModel::Model

  attr_accessor :user, :reaction, :answer, :event_url_path

  validates :answer, presence: true
  validates :event_url_path, presence: true
  validates :user, presence: true

  def create
    return false if invalid?
    transaction(user, answer)
  end

  private
    def transaction(user, answer)
      ActiveRecord::Base.transaction do
        answer.each do |event_date_id, status|
          reaction = user.reactions.new(user: user, event_date_id: event_date_id, status: status)
          reaction.save!
        end
      end
    end
end
