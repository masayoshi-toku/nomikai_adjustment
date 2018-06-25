FactoryBot.define do
  factory :event_date do
    sequence(:event_date) { |n| Date.current.since(n.days).strftime('%Y/%m/%d') }
    association :event, factory: :event
  end
end
