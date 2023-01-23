FactoryBot.define do
  factory :person do
    name { Faker::Movies::HarryPotter.character.titleize }
    birthdate { Faker::Date.birthday(min_age: 1, max_age: 100) }
    weight { Faker::Number.within(range: 2.5..150.0) }
    body_build { get_random_body_build(rand(0..2)) }
  end

  trait :young do
    birthdate { Faker::Date.birthday(min_age: 10, max_age: 35) }
  end

  trait :old do
    birthdate { Faker::Date.birthday(min_age: 50, max_age: 100) }
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
