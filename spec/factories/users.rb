# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Jack'
    sequence(:email) { |n| "user-#{ n }@example.com" }
  end
end
