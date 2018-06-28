class User < ApplicationRecord
  validates :name, presence: true
  VALID_DOMAIN_REGEX = /@mwed.co.jp\z/
  validates :email, presence: true, uniqueness: true, format: { with: VALID_DOMAIN_REGEX }
  has_many :events
  has_many :reactions
end
