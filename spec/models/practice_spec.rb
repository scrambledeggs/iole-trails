require 'rails_helper'

RSpec.describe Practice, type: :model do
  let(:person_attribute) { :FIT }
  let(:person1) { create(:person, person_attribute) }

  let(:trail_attribute) { :FIT }
  let(:trail1) { create(:trail, trail_attribute) }

  subject(:practice1) { build(:practice, person: person1, trail: trail1) }

  context 'when person is eligible' do
    it { is_expected.to be_valid }
  end

  context 'when person has ineligible body build' do
    let(:person_attribute) { :SLIM }

    it { is_expected.not_to be_valid }
  end

  context 'when person has ineligible age' do
    let(:person_attribute) { :young }
    let(:trail_attribute) { :for_old }

    it { is_expected.not_to be_valid }
  end

  context 'when person has ineligible weight' do
    let(:person_attribute) { :light }
    let(:trail_attribute) { :for_heavy }

    it { is_expected.not_to be_valid }
  end

  context 'when a person has an ongoing race' do
    let!(:race1) { create(:race, trail: trail1) }

    let!(:practice2) { create(:practice, :FINISHED, person: person1, trail: trail1) }
    let!(:run1) { create(:run, person: person1, race: race1) }

    let!(:person2) { create(:person, :FIT) }
    let!(:practice3) { create(:practice, :FINISHED, person: person2, trail: trail1) }
    let!(:run2) { create(:run, person: person2, race: race1) }

    let!(:status_update) { race1.update(status: :STARTED) }

    it { is_expected.not_to be_valid }
  end
end
