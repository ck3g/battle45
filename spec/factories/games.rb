# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    user
    status 'start'
    sequence(:remote_id)
    ships %w[Carrier Battleship Submarine Submarine]

    trait :defeat do
      status 'defeat'
    end

    factory :defeated_game, traits: [:defeat]
  end
end
