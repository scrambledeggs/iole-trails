require 'rails_helper'

RSpec.describe RaceUpdater do
  let(:trail_attribute) { :FIT }
  let!(:trail) { create(:trail, trail_attribute) }
  let!(:person1) { create(:person, :FIT) }

  subject(:race1) { create(:race, trail: trail) }

  context 'when an ongoing race is finished' do
    let!(:practice1) { create(:practice, :FINISHED, person: person1, trail: trail) }
    let!(:run1) { create(:run, person: person1, race: race1) }

    let!(:person2) { create(:person, :FIT) }
    let!(:practice2) { create(:practice, :FINISHED, person: person2, trail: trail) }
    let!(:run2) { create(:run, person: person2, race: race1) }

    let!(:return_value) { RaceUpdater.call(race1, :FINISHED, true) }

    it { expect(return_value[:result]).to be_truthy }
    it { expect(return_value[:message]).to be_nil }
    it { expect(race1.status).to eq 'FINISHED' }
    it { expect(race1.winner).not_to be_nil }

    it 'assigns a random run status and run duration' do
      run1_record = Run.find(run1.id)
      run2_record = Run.find(run2.id)

      expect(run1_record.status).to include('FINISHED')
      expect(run2_record.status).to include('FINISHED')
      expect(run1_record.duration).not_to be_nil
      expect(run2_record.duration).not_to be_nil
    end
  end

  context 'when status for update is invalid' do
    let!(:return_value) { RaceUpdater.call(race1, :STARTED) }

    it { expect(return_value[:result]).to be_falsey }
    it { expect(return_value[:message]).to match('Invalid race status update') }
  end

  context 'when runs cannot be updated' do
    before do
      allow(Run).to receive(:update).and_return(false)
    end

    let!(:return_value) { RaceUpdater.call(race1, :FINISHED, true) }

    it { expect(return_value[:result]).to be_falsey }
    it { expect(return_value[:message]).to match('Could not update runs with random') }
  end
end
