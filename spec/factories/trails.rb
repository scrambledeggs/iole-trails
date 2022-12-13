FactoryBot.define do
  factory :trail do
    name { Faker::Movies::HarryPotter.location }
  end

  trait :for_young do
    age_minimum { 10 }
    age_maximum { 35 }
  end

  trait :for_old do
    age_minimum { 50 }
    age_maximum { 100 }
  end

  trait :for_light do
    weight_minimum { 2.5 }
    weight_maximum { 40.0 }
  end

  trait :for_heavy do
    weight_minimum { 70.0 }
    weight_maximum { 150.0 }
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
