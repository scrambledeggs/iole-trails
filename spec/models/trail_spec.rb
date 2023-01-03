require 'rails_helper'

RSpec.describe Trail, type: :model do
  it 'is valid with valid attributes' do
    trail1 = create(:trail)
    expect(trail1).to be_valid
  end

  it 'is not valid without a name' do
    trail2 = build(:trail, name: nil)
    expect(trail2).not_to be_valid
  end

  it 'is valid without an age minimum' do
    trail2 = build(:trail, age_minimum: nil)
    expect(trail2).to be_valid
  end

  it 'is valid without an age maximum' do
    trail2 = build(:trail, age_maximum: nil)
    expect(trail2).to be_valid
  end

  it 'is valid without a weight minimum' do
    trail2 = build(:trail, weight_minimum: nil)
    expect(trail2).to be_valid
  end

  it 'is valid without a weight maximum' do
    trail2 = build(:trail, weight_maximum: nil)
    expect(trail2).to be_valid
  end

  it 'is valid without a body build' do
    trail2 = build(:trail, body_build: nil)
    expect(trail2).to be_valid
  end

  describe 'eligible?' do
    subject(:trail1) { create(:trail, :FIT, :for_young, :for_heavy) }

    let(:weight) { 70 }
    let(:body_build) { 'FIT' }

    context 'when input is eligible' do
      let(:age) { 20 }

      it { expect(trail1.eligible?(age, weight, body_build)).to eq true }
    end

    context 'when input is not eligible' do
      let(:age) { 50 }

      it { expect(trail1.eligible?(age, weight, body_build)).to eq false }
    end
  end

  describe 'ongoing_practices' do
    subject(:trail1) { create(:trail, :for_young_only) }
    let!(:person1) { create(:person, :young, :heavy) }
    let!(:practice1) { create(:practice, :FINISHED, person: person1, trail: trail1) }
    let!(:person2) { create(:person, :young, :light) }
    let!(:practice2) { create(:practice, :STARTED, person: person2, trail: trail1) }

    it { expect(trail1.ongoing_practices?).to eq true }
    it { expect(trail1.ongoing_practices.count).to eq 1 }
  end

  describe 'past_practices' do
    subject(:trail1) { create(:trail, :for_young_only) }

    let!(:person1) { create(:person, :young, :heavy) }
    let!(:practice1) { create(:practice, :FINISHED, person: person1, trail: trail1) }
    let!(:person2) { create(:person, :young, :light) }
    let!(:practice2) { create(:practice, :STARTED, person: person2, trail: trail1) }

    it { expect(trail1.past_practices?).to eq true }
    it { expect(trail1.past_practices.count).to eq 1 }
  end
end
