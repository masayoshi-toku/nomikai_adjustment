FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@mwed.co.jp" }
    sequence(:name) { |n| "Mr.example#{n}" }
  end
end
