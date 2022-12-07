FactoryBot.define do
  factory :race do
    association :trail
    sequence(:name) { |n| "race#{n}" }
    status { :NEW }
    sequence(:start) { |n| n.days.from_now }
    duration { 1.5 }
  end

  trait :with_winner do
    winner { 1 }
  end
end
