FactoryBot.define do
  factory :event_date do
    event_date '2018-01-01'.to_time
    association :event, factory: :event
  end
end
