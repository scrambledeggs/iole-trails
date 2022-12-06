FactoryBot.define do
  factory :trail do
    sequence(:name) { |n| "trail#{n}" }
    age_minimum { 1 }
    age_maximum { 10 }
    weight_minimum { 1.5 }
    weight_maximum { 10.5 }
    body_build { 'SLIM' }
  end

  # create traits that are realistic parameters
end
