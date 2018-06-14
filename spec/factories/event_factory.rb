FactoryBot.define do
  factory :event do
    title '第一回飲み会'
    association :user, factory: :user
  end
end
