FactoryBot.define do
  factory :event do
    title '第一回飲み会'
    url_path 'this.is.20characters'
    association :user, factory: :user
  end
end
