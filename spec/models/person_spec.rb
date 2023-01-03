require 'rails_helper'

RSpec.describe Person, type: :model do
  it 'is valid with valid attributes' do
    person1 = create(:person)
    expect(person1).to be_valid
  end

  it 'is not valid without a name' do
    person1 = build(:person, name: nil)
    expect(person1).not_to be_valid
  end

  it 'is not valid without an age' do
    person1 = build(:person, age: nil)
    expect(person1).not_to be_valid
  end

  it 'is not valid without a weight' do
    person1 = build(:person, weight: nil)
    expect(person1).not_to be_valid
  end

  it 'is not valid without a body build' do
    person1 = build(:person, body_build: nil)
    expect(person1).not_to be_valid
  end

  describe 'ongoing_practice' do
    subject!(:person1) { create(:person, :FIT) }

    context 'when a person has ongoing practice' do
      let!(:practice1) { create(:practice, :for_fit, person: person1) }

      it { expect(person1.ongoing_practice?).to eq true }
      it { expect(person1.ongoing_practice.id).to eq practice1.id }
    end

    context 'when a person does not have ongoing practice' do
      it { expect(person1.ongoing_practice?).to eq false }
      it { expect(person1.ongoing_practice).to be_nil }
    end
  end

  describe 'past_practices' do
    subject!(:person1) { create(:person, :FIT) }

    context 'when a person has a finished practice' do
      let!(:practice1) { create(:practice, :FINISHED, :for_fit, person: person1) }

      it { expect(person1.past_practices?).to eq true }
      it { expect(person1.past_practices.count).to eq 1 }
    end

    context 'when a person does not have a finished practice' do
      it { expect(person1.past_practices?).to eq false }
      it { expect(person1.past_practices.count).to eq 0 }
    end
  end

  describe 'ongoing_race' do
    subject!(:person1) { create(:person, :FIT) }

    let!(:trail1) { create(:trail, :FIT) }
    let!(:race1) { create(:race, trail: trail1) }

    let!(:practice1) { create(:practice, :FINISHED, person: person1, trail: trail1) }
    let!(:run1) { create(:run, person: person1, race: race1) }

    let!(:person2) { create(:person, :FIT) }
    let!(:practice2) { create(:practice, :FINISHED, person: person2, trail: trail1) }
    let!(:run2) { create(:run, person: person2, race: race1) }

    context 'when a person does not have an ongoing race' do
      it { expect(person1.ongoing_race?).to eq false }
      it { expect(person1.ongoing_race).to be_nil }
    end

    context 'when a person has an ongoing race' do
      let!(:race_update) { race1.update(status: :STARTED) }

      it { expect(person1.ongoing_race?).to eq true }
      it { expect(person1.ongoing_race.id).to eq race1.id }
    end
  end

  describe 'registered_runs' do
    subject!(:person1) { create(:person, :FIT) }

    let!(:trail1) { create(:trail, :FIT) }
    let!(:race1) { create(:race, trail: trail1) }

    let!(:practice1) { create(:practice, :FINISHED, person: person1, trail: trail1) }
    let!(:run1) { create(:run, person: person1, race: race1, status: status) }

    context 'when a person has a registered run' do
      let!(:status) { :REGISTERED }

      it { expect(person1.registered_runs.count).to eq 1 }
    end

    context 'when a person has a dropped run' do
      let(:status) { :DROPPED }

      it { expect(person1.registered_runs.count).to eq 0 }
    end
  end

  describe 'practice_on' do
    let!(:trail1) { create(:trail, :for_young, :FIT) }

    context 'when a person is eligible for the trail' do
      subject!(:person1) { create(:person, :young, :FIT) }

      it { expect(person1.practice_on?(trail1)).to eq true }
    end

    context 'when a person is ineligible for the trail' do
      subject!(:person1) { create(:person, :old) }

      it { expect(person1.practice_on?(trail1)).to eq false }
    end
  end

  describe 'finished_practice_on' do
    subject!(:person1) { create(:person, :FIT) }

    let!(:trail1) { create(:trail, :FIT) }

    let!(:practice1) { create(:practice, status: status, person: person1, trail: trail1) }

    context 'when a person has a finished practice' do
      let!(:status) { :FINISHED }

      it { expect(person1.finished_practice_on?(trail1.id)).to eq true }
    end

    context 'when a person has an unfinished practice' do
      let!(:status) { :STARTED }

      it { expect(person1.finished_practice_on?(trail1.id)).to eq false }
    end
  end
end
