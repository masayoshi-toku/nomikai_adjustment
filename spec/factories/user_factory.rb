FactoryBot.define do
  sequence :email do |n|
    "example#{n}@mwed.co.jp"
  end

  sequence :name do |n|
    "Mr.example#{n}"
  end

  factory :user do
    name
    email
  end
end
