FactoryBot.define do
  factory :trail do
    sequence(:name) { |n| "trail#{n}" }
    age_minimum { 1 }
    age_maximum { 10 }
    weight_minimum { 1.5 }
    weight_maximum { 10.5 }
    body_build { :SLIM }
  end

  trait :for_young do
    age_minimum { 15 }
    age_maximum { 35 }
  end

  trait :for_old do
    age_minimum { 50 }
    age_maximum { 65 }
  end

  trait :for_light do
    weight_minimum { 30 }
    weight_maximum { 40 }
  end

  trait :for_heavy do
    weight_minimum { 70 }
    weight_maximum { 100 }
  end

  trait :for_young_only do
    for_young
    weight_minimum { nil }
    weight_maximum { nil }
    body_build { nil }
  end

  trait :for_heavy_only do
    for_heavy
    age_minimum { nil }
    age_maximum { nil }
    body_build { nil }
  end
end
