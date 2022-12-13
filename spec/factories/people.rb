FactoryBot.define do
  factory :person do
    name { Faker::Movies::HarryPotter.character }
    age { Faker::Number.within(range: 1..100) }
    weight { Faker::Number.within(range: 2.5..150.0) }
    body_build { get_random_body_build(rand(0..2)) }
  end

  trait :young do
    age { Faker::Number.within(range: 10..35) }
  end

  trait :old do
    age { Faker::Number.within(range: 50..100) }
  end

  trait :light do
    weight { Faker::Number.within(range: 2.5..40.0) }
  end

  trait :heavy do
    weight { Faker::Number.within(range: 70.0..150.0) }
  end
end

def get_random_body_build(index)
  builds = %i[SLIM FIT LARGE]
  builds[index]
end