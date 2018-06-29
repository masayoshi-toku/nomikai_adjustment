FactoryBot.define do
  factory :event do
    association :user, factory: :user
    sequence(:title) { |n| "第#{n}回飲み会" }
    sequence(:url_path) { |n| "this%is@SaMplecharacters#{n}" }
  end
end
