class ReactionForm
  include ActiveModel::Model

  attr_accessor :user, :reaction, :status, :event_url_path

  validates :status, presence: true
  validates :event_url_path, presence: true
  validates :user, presence: true

  def create
    return false if invalid?
    transaction(user, status)
  end

  private
    def transaction(user, status)
      ActiveRecord::Base.transaction do
        status.each do |event_date_id, status|
          reaction = user.reactions.new(user: user, event_date_id: event_date_id, status: status)
          reaction.save!
        end
      end
    end
end
