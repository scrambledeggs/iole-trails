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
end
