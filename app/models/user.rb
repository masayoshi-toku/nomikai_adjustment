class User < ApplicationRecord
  validates :name, presence: true
  VALID_DOMAIN_REGEX = /@mwed.co.jp\z/
  validates :email, presence: true, uniqueness: true, format: { with: VALID_DOMAIN_REGEX }

  def self.find_or_new_from(user_params)
    user = User.find_by(email: user_params[:email])
    unless user
      user = User.new(user_params)
    end
    return user
  end
end
