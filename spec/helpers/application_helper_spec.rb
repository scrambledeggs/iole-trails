require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe 'status_tag' do
    let(:expected_line) { "<mark class=#{status_color}>#{status}</mark>".html_safe }

    context 'when status is registered' do
      let!(:status) { 'REGISTERED' }
      let!(:status_color) { 'new' }

      it { expect(helper.status_tag(status)).to match(expected_line) }
    end

    context 'when status is started' do
      let!(:status) { 'STARTED' }
      let!(:status_color) { 'ongoing' }

      it { expect(helper.status_tag(status)).to match(expected_line) }
    end

    context 'when status is finished' do
      let!(:status) { 'FINISHED' }
      let!(:status_color) { 'finished' }

      it { expect(helper.status_tag(status)).to match(expected_line) }
    end

    context 'when status is dropped' do
      let!(:status) { 'DROPPED' }
      let!(:status_color) { 'unfinished' }

      it { expect(helper.status_tag(status)).to match(expected_line) }
    end

    context 'when status is not expected' do
      let!(:status) { 'RANDOM' }
      let!(:status_color) { '' }

      it { expect(helper.status_tag(status)).to match(expected_line) }
    end
  end
end
