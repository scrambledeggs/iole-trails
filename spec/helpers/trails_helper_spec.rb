require 'rails_helper'

RSpec.describe TrailsHelper do
  describe 'age_criteria_line' do
    let!(:trail) { create(:trail, age_minimum: min, age_maximum: max) }

    context 'with min and max' do
      subject(:age_criteria_line) { helper.age_criteria_line(trail) }

      let!(:min) { 16 }
      let!(:max) { 20 }

      it { expect(age_criteria_line).to match("#{min} to #{max}") }
    end

    context 'without max' do
      subject(:age_criteria_line) { helper.age_criteria_line(trail) }

      let!(:min) { 16 }
      let!(:max) { nil }

      it { expect(age_criteria_line).to match("At least #{min}") }
    end

    context 'without min' do
      subject(:age_criteria_line) { helper.age_criteria_line(trail) }

      let!(:min) { nil }
      let!(:max) { 20 }

      it { expect(age_criteria_line).to match("Up to #{max}") }
    end

    context 'without min and max' do
      subject(:age_criteria_line) { helper.age_criteria_line(trail) }

      let!(:min) { nil }
      let!(:max) { nil }

      it { expect(age_criteria_line).to match('Any') }
    end
  end

  describe 'weight_criteria_line' do
    let!(:trail) { create(:trail, weight_minimum: min, weight_maximum: max) }

    context 'with min and max' do
      subject(:weight_criteria_line) { helper.weight_criteria_line(trail) }

      let!(:min) { 30.0 }
      let!(:max) { 50.0 }

      it { expect(weight_criteria_line).to match("#{min} to #{max}") }
    end

    context 'without max' do
      subject(:weight_criteria_line) { helper.weight_criteria_line(trail) }

      let!(:min) { 30.0 }
      let!(:max) { nil }

      it { expect(weight_criteria_line).to match("At least #{min}") }
    end

    context 'without min' do
      subject(:weight_criteria_line) { helper.weight_criteria_line(trail) }

      let!(:min) { nil }
      let!(:max) { 50.0 }

      it { expect(weight_criteria_line).to match("Up to #{max}") }
    end

    context 'without min and max' do
      subject(:weight_criteria_line) { helper.weight_criteria_line(trail) }

      let!(:min) { nil }
      let!(:max) { nil }

      it { expect(weight_criteria_line).to match('Any') }
    end
  end

  describe 'body_build_criteria_line' do
    let!(:trail) { create(:trail, body_build: criteria) }

    context 'with criteria' do
      subject(:body_build_criteria_line) { helper.body_build_criteria_line(trail) }

      let!(:criteria) { :SLIM }

      it { expect(body_build_criteria_line).to match("SLIM") }
    end

    context 'without criteria' do
      subject(:body_build_criteria_line) { helper.body_build_criteria_line(trail) }

      let!(:criteria) { nil }

      it { expect(body_build_criteria_line).to match('Any') }
    end
  end
end
