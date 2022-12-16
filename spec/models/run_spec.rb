require 'rails_helper'

RSpec.describe Run, type: :model do
  let!(:trail1) { create(:trail, :FIT) }
  let!(:race1) { create(:race, trail: trail1) }

  let!(:person1) { create(:person, :FIT) }
  subject(:run1) { build(:run, person: person1, race: race1) }

  context 'when person is eligible' do
    let!(:finished_practice) { create(:practice, :FINISHED, person: person1, trail: trail1) }

    it { is_expected.to be_valid }

    it 'is invalid if same run is already registered' do
      create(:run, person: person1, race: race1)

      expect(run1).not_to be_valid
    end

    it 'is invalid if with ongoing race' do
      race2 = create(:race, :STARTED, trail: trail1)
      run2 = build(:run, person: person1, race: race2)

      expect(run2).not_to be_valid
    end

    it 'is invalid when person has other overlapping races' do
      trail2 = create(:trail, :FIT)
      race2 = create(:race, trail: trail2, start: race1.start)
      create(:practice, :FINISHED, person: person1, trail: trail2)
      create(:run, person: person1, race: race2)

      expect(run1).not_to be_valid
    end
  end

  context 'when person does not have finished practice for trail' do
    it { is_expected.not_to be_valid }
  end

  context 'when person has ongoing practice' do
    let!(:ongoing_practice) { create(:practice, :STARTED, person: person1, trail: trail1) }

    it { is_expected.not_to be_valid }
  end
end
