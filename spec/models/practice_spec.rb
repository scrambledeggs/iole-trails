require 'rails_helper'

RSpec.describe Practice, type: :model do
  it 'is valid for eligible people' do
    person1 = create(:person, :FIT)
    trail1 = create(:trail, :FIT)
    practice1 = create(:practice, person: person1, trail: trail1)
    expect(practice1).to be_valid
  end

  it 'is invalid for people with ineligible body build' do
    person1 = create(:person, :SLIM)
    trail1 = create(:trail, :FIT)
    practice1 = build(:practice, person: person1, trail: trail1)
    expect(practice1).not_to be_valid
  end

  it 'is invalid for people with ineligible age' do
    person1 = create(:person, :young)
    trail1 = create(:trail, :for_old)
    practice1 = build(:practice, person: person1, trail: trail1)
    expect(practice1).not_to be_valid
  end

  it 'is invalid for people with ineligible weight' do
    person1 = create(:person, :light)
    trail1 = create(:trail, :for_heavy)
    practice1 = build(:practice, person: person1, trail: trail1)
    expect(practice1).not_to be_valid
  end

  # TODO: is invalid for unavailable people
end
