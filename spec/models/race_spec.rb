require 'rails_helper'

RSpec.describe Race, type: :model do
  let(:trail_attribute) { :FIT }
  let!(:trail) { create(:trail, trail_attribute) }
  let!(:person1) { create(:person, :FIT) }

  subject!(:race1) { create(:race, trail: trail) }

  context 'when valid attributes' do
    it { expect(race1).to be_valid }
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
    let!(:race2) { create(:race, trail: trail) }

    it 'cannot create an overlapping race' do
      race3 = build(:race, trail: trail, start: race1.start)

      expect(race3).not_to be_valid
    end

    it 'cannot edit a race to overlap another' do
      race2.update(start: race1.start)

      expect(race2.errors.messages_for(:time_period)).not_to be_empty
    end
  end

  context 'with no participants' do
    it 'is allowed to change details' do
      new_name = 'new_race_name'

      race1.update(name: new_name)

      expect(race1.name).to eq new_name
    end

    it 'is not allowed to change status to STARTED' do
      race1.update(status: :STARTED)

      expect(race1.errors.messages_for(:status)).not_to be_empty
    end
  end

  context 'with a participant' do
    let!(:practice1) { create(:practice, :FINISHED, person: person1, trail: trail) }
    let!(:run1) { create(:run, person: person1, race: race1) }

    it 'is not allowed to change details' do
      race1.update(name: 'new_race_name')

      expect(race1.errors.messages_for(:detail)).not_to be_empty
    end

    it 'is allowed to change status' do
      person2 = create(:person, :FIT)
      create(:practice, :FINISHED, person: person2, trail: trail)
      create(:run, person: person2, race: race1)

      race1.update(status: :STARTED)

      expect(race1.status).to eq 'STARTED'
    end
  end

  context 'when an ongoing race is finished' do
    let!(:practice1) { create(:practice, :FINISHED, person: person1, trail: trail) }
    let!(:run1) { create(:run, person: person1, race: race1) }

    let!(:person2) { create(:person, :FIT) }
    let!(:practice2) { create(:practice, :FINISHED, person: person2, trail: trail) }
    let!(:run2) { create(:run, person: person2, race: race1) }

    let!(:finish_race) { race1.update(status: :FINISHED) }

    it { expect(race1.status).to eq 'FINISHED' }
    it { expect(race1.winner).not_to be_nil }

    it 'assigns a random run status and run duration' do
      run1_record = Run.find(run1.id)
      run2_record = Run.find(run2.id)

      expect(run1_record.status).to include('FINISHED')
      expect(run2_record.status).to include('FINISHED')
      expect(run1_record.duration).not_to be_nil
      expect(run2_record.duration).not_to be_nil
    end
  end

  describe 'expected_end' do
    it { expect(race1.expected_end).to eq (race1.start + race1.duration.hours) }
  end

  describe 'overlaps?' do
    let(:duration) { 1 }

    context 'when input is within race time period' do
      let(:start) { race1.start }
      it { expect(race1.overlaps?(start, duration)).to eq true }
    end

    context 'when input is outside race time period' do
      let(:start) { race1.start + 1.day }

      it { expect(race1.overlaps?(start, duration)).to eq false }
    end

    context 'when input is exactly after race time period' do
      let(:start) { race1.expected_end }

      it { expect(race1.overlaps?(start, duration)).to eq false }
    end
  end
end
