FactoryBot.define do
  factory :run do
    status { :REGISTERED }

    association :person
    association :race

    trait :with_finished_stats do
      duration { 1 }
      place { 1 }
    end

    trait :with_unfinished_stats do
      duration { 2 }
      place { 2 }
    end
  end
end
