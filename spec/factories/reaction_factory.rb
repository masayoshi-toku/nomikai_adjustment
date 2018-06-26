FactoryBot.define do
  factory :reaction do
    association :user, factory: :user
    association :event_date, factory: :event_date
    status 1
  end
end
