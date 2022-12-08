require 'rails_helper'

RSpec.describe Run, type: :model do
  let!(:trail1) { create(:trail, :FIT) }
  let!(:race1) { create(:race, trail: trail1) }

  let!(:person1) { create(:person, :FIT) }
  it 'is valid for eligible and available people' do
    create(:practice, :FINISHED, :for_fit, person: person1, trail: trail1)

    run1 = build(:run, person: person1, race: race1)
    expect(run1).to be_valid
  end

  it 'is invalid if same run is already registered' do
    create(:practice, :FINISHED, :for_fit, person: person1, trail: trail1)
    create(:run, person: person1, race: race1)
    run2 = build(:run, person: person1, race: race1)

    expect(run2).not_to be_valid
  end

  it 'is invalid for ineligible people' do
    run1 = build(:run, person: person1, race: race1)
    expect(run1).not_to be_valid
  end

  it 'is invalid for unavailable people' do
    create(:practice, :STARTED, :for_fit, person: person1, trail: trail1)

    run1 = build(:run, person: person1, race: race1)
    expect(run1).not_to be_valid
  end

  it 'is invalid for an ongoing race' do
    create(:practice, :FINISHED, :for_fit, person: person1, trail: trail1)
    race2 = create(:race, :STARTED, trail: trail1)

    run1 = build(:run, person: person1, race: race2)
    expect(run1).not_to be_valid
  end

  it 'is invalid if overlaps another registered race' do
    trail2 = create(:trail, :FIT)
    race2 = create(:race, trail: trail2, start: race1.start)

    create(:practice, :FINISHED, :for_fit, person: person1, trail: trail1)
    create(:practice, :FINISHED, :for_fit, person: person1, trail: trail2)

    create(:run, person: person1, race: race1)

    run2 = build(:run, person: person1, race: race2)
    expect(run2).not_to be_valid
  end
end
