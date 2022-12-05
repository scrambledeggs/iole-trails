FactoryBot.define do
  factory :person do
    sequence(:name) { |n| "person#{n}" }
    age { 1 }
    weight { 1.5 }
    body_build { 'FIT' }
  end
end
