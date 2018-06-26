class ReactionForm
  include ActiveModel::Model

  attr_accessor :user, :reaction, :answer, :event_url_path

  validates :answer, presence: true
  validates :event_url_path, presence: true
  validates :user, presence: true

  def create
    return false if invalid?
    save_reaction(user, answer)
  end

  private
    def save_reaction(user, answer)
      answer.each do |event_date_id, status|
        user.reactions.new(event_date_id: event_date_id, status: status)
      end
      user.save
    end
end
