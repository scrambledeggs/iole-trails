require 'rails_helper'

RSpec.describe Person, type: :model do
  it 'is valid with valid attributes' do
    person1 = create(:person)
    expect(person1).to be_valid
  end

  it 'is not valid without a name' do
    person2 = build(:person, name: nil)
    expect(person2).not_to be_valid
  end

  it 'is not valid without an age' do
    person2 = build(:person, age: nil)
    expect(person2).not_to be_valid
  end

  it 'is not valid without a weight' do
    person2 = build(:person, weight: nil)
    expect(person2).not_to be_valid
  end

  it 'is not valid without a body build' do
    person2 = build(:person, body_build: nil)
    expect(person2).not_to be_valid
  end

  describe 'ongoing_practice' do
    let!(:person1) { create(:person, :FIT) }

    context 'for a person with ongoing practice' do
      let!(:practice1) { create(:practice, :for_fit, person: person1) }

      it { expect(person1.ongoing_practice?).to eq true }
      it { expect(person1.ongoing_practice.id).to eq practice1.id }
    end

    context 'for a person without ongoing practice' do
      it { expect(person1.ongoing_practice?).to eq false }
      it { expect(person1.ongoing_practice).to be_nil }
    end
  end

  describe 'past_practices' do
    let!(:person1) { create(:person, :FIT) }

    context 'for a person with a finished practice' do
      let!(:practice1) { create(:practice, :FINISHED, :for_fit, person: person1) }

      it { expect(person1.past_practices?).to eq true }
      it { expect(person1.past_practices.count).to eq 1 }
    end

    context 'for a person without a finished practice' do
      it { expect(person1.past_practices?).to eq false }
      it { expect(person1.past_practices.count).to eq 0 }
    end
  end

  describe 'ongoing_race' do
    let!(:trail1) { create(:trail, :FIT) }
    let!(:race1) { create(:race, trail: trail1) }

    let!(:person1) { create(:person, :FIT) }
    let!(:practice1) { create(:practice, :FINISHED, :for_fit, person: person1, trail: trail1) }
    let!(:run1) { create(:run, person: person1, race: race1) }

    let!(:person2) { create(:person, :FIT) }
    let!(:practice2) { create(:practice, :FINISHED, :for_fit, person: person2, trail: trail1) }
    let!(:run2) { create(:run, person: person2, race: race1) }

    context 'for a person without an ongoing race' do
      it { expect(person1.ongoing_race?).to eq false }
      it { expect(person1.ongoing_race).to be_empty } # TODO: should be nil, change model
    end

    context 'for a person with an ongoing race' do
      it 'returns true' do
        race1.update(status: :STARTED)
        expect(person1.ongoing_race?).to eq true
        expect(person1.ongoing_race[0].id).to eq race1.id
      end
    end
  end

  describe 'registered_runs' do
    let!(:trail1) { create(:trail, :FIT) }
    let!(:race1) { create(:race, trail: trail1) }

    let!(:person1) { create(:person, :FIT) }
    let!(:practice1) { create(:practice, :FINISHED, :for_fit, person: person1, trail: trail1) }

    context 'for a person with a registered run' do
      let!(:run1) { create(:run, person: person1, race: race1) }

      it { expect(person1.registered_runs.count).to eq 1 }
    end

    context 'for a person with a dropped run' do
      let!(:run1) { create(:run, :DROPPED, person: person1, race: race1) }

      it { expect(person1.registered_runs.count).to eq 0 }
    end
  end

  describe 'practice_on' do
    pending 'hehe'
  end

  describe 'get_trail_options' do
    pending 'hehe'
  end

  describe 'finished_practice_on' do
    pending 'hehe'
  end
end
