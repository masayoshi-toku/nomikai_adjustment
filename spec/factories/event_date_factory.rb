FactoryBot.define do
  factory :event_date do
    event_date '2018-01-01'
    association :event, factory: :event
  end
end
