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

  context 'when a person has an ongoing race' do
    let!(:trail1) { create(:trail, :FIT) }
    let!(:race1) { create(:race, trail: trail1) }

    let!(:person1) { create(:person, :FIT) }
    let!(:practice1) { create(:practice, :FINISHED, :for_fit, person: person1, trail: trail1) }
    let!(:run1) { create(:run, person: person1, race: race1) }

    let!(:person2) { create(:person, :FIT) }
    let!(:practice2) { create(:practice, :FINISHED, :for_fit, person: person2, trail: trail1) }
    let!(:run2) { create(:run, person: person2, race: race1) }

    it 'is invalid' do
      race1.update(status: :STARTED)

      practice3 = build(:practice, person: person1, trail: trail1)
      expect(practice3).not_to be_valid
    end
  end
end
