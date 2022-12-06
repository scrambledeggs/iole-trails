FactoryBot.define do
  factory :practice do
    status { :STARTED }

    association :person
    association :trail

    trait :for_fit do
      association :trail, :FIT
      association :person, :FIT
    end
  end
end
