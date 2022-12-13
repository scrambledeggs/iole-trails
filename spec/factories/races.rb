FactoryBot.define do
  factory :race do
    association :trail
    name { Faker::Movies::HarryPotter.spell }
    status { :NEW }
    sequence(:start) { |n| n.days.from_now }
    duration { Faker::Number.within(range: 0.5..12.0) }
  end

  trait :with_winner do
    winner { 1 }
  end
end
