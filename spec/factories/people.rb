FactoryBot.define do
  factory :person do
    sequence(:name) { |n| "person#{n}" }
    age { 1 }
    weight { 1.5 }
    body_build { :FIT }
  end

  trait :young do
    age { 20 }
  end

  trait :old do
    age { 60 }
  end

  trait :light do
    weight { 35 }
  end

  trait :heavy do
    weight { 85 }
  end
end
