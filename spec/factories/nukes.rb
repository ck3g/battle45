# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nuke do
    game
    x 1
    y 1
    target 'user'
  end
end
