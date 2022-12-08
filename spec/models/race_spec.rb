require 'rails_helper'

RSpec.describe Race, type: :model do
  it 'is valid with valid attributes' do
    race1 = create(:race)
    expect(race1).to be_valid
  end

  it 'is not valid without a name' do
    race2 = build(:race, name: nil)
    expect(race2).not_to be_valid
  end

  it 'is not valid without a duration' do
    race2 = build(:race, duration: nil)
    expect(race2).not_to be_valid
  end

  it 'is not valid without a start date' do
    race2 = build(:race, start: nil)
    expect(race2).not_to be_valid
  end

  context 'when other races exist' do
    let!(:trail) { create(:trail) }
    let!(:race1) { create(:race, trail: trail) }
    let!(:race2) { create(:race, trail: trail) }

    it 'cannot create an overlapping race' do
      race3 = build(:race, start: race1.start, trail: trail)

      expect(race3).not_to be_valid
    end

    it 'cannot edit a race to overlap' do
      race2.update(start: race1.start)

      expect(race2.errors).not_to be_empty
    end
  end

  context 'with no participants' do
    let!(:trail) { create(:trail) }
    let!(:race1) { create(:race, trail: trail) }

    it 'is allowed to change details' do
      new_name = 'new_race_name'

      race1.update(name: new_name)

      expect(race1.name).to eq new_name
    end

    it 'is not allowed to change status to STARTED' do
      race1.update(status: :STARTED)

      expect(race1.errors).not_to be_empty
    end
  end

  context 'with a participant' do
    let!(:trail1) { create(:trail, :FIT) }
    let!(:person1) { create(:person, :FIT) }
    let!(:practice1) { create(:practice, :FINISHED, person: person1, trail: trail1) }
    let!(:race1) { create(:race, trail: trail1) }
    let!(:run1) { create(:run, person: person1, race: race1, id: 1) }

    it 'is not allowed to change details' do
      race1.update(name: 'new_race_name')

      expect(race1.errors).not_to be_empty
    end

    it 'is allowed to change status' do
      person2 = create(:person, :FIT)
      practice2 = create(:practice, :FINISHED, person: person2, trail: trail1)
      run2 = create(:run, person: person2, race: race1, id: 2)

      race1.update(status: :STARTED)

      expect(race1.status).to eq 'STARTED'
    end
  end

  # TODO: finish_sequence
end
