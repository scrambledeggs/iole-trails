require 'rails_helper'

RSpec.describe PracticesHelper do
  describe 'get_trail_options' do
    subject!(:person1) { create(:person, :young, :FIT, :light) }

    let!(:trail1) { create(:trail, :for_young, :for_light, :FIT) }
    let!(:trail2) { create(:trail, :for_young_only) }
    let!(:trail3) { create(:trail, :for_heavy_only) }

    context 'with eligible and ineligible trails' do
      let(:trail_options) { helper.trail_options(person1) }

      it { expect(trail_options[0][0]).to eq trail1.name }
      it { expect(trail_options[1][0]).to eq trail2.name }
      it { expect(trail_options[2][0]).to eq "#{trail3.name} (ineligible)" }
    end
  end
end
