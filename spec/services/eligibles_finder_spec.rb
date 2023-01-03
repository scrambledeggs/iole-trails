require 'rails_helper'

RSpec.describe EligiblesFinder do
  describe 'call' do
    subject(:trail1) { create(:trail, :for_heavy_only) }

    let!(:person1) { create(:person, :FIT, :young, :heavy) }
    let!(:person2) { create(:person, :young, :light) }
    let!(:person3) { create(:person, :heavy) }

    it { expect(EligiblesFinder.call(trail1).count).to eq 2 }
  end
end
