require 'rails_helper'

RSpec.describe RacesHelper do
  describe 'participant_line' do
    subject(:participant_line) { helper.participant_line(run) }

    let!(:person) { create(:person, :SLIM) }
    let!(:trail) { create(:trail, :SLIM) }
    let!(:race) { create(:race, trail: trail) }
    let!(:practice) { create(:practice, :FINISHED, person: person, trail: trail) }
    let!(:run) { create(:run, race: race, person: person, duration: duration) }

    context 'when a run is registered' do
      let!(:duration) { nil }
      it { expect(participant_line).to match("<li>#{person.name.capitalize}</li>") }
    end

    context 'when a run has duration' do
      let!(:duration) { 3.50 }

      it { expect(participant_line).to match("<li>#{person.name.capitalize} (#{number_with_precision(run.duration, precision: 2)}h)</li>") }
    end
  end
end
