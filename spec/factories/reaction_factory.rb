FactoryBot.define do
  factory :reaction do
    status 1
    association :user, factory: :user
    association :event_date, factory: :event_date
  end
end
