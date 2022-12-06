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
end
