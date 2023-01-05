require 'rails_helper'

RSpec.describe 'RunsController', type: :request do
  subject(:actual_run) { assigns(:run) }

  let!(:trail) { create(:trail, :SLIM) }
  let!(:race) { create(:race, trail: trail) }
  let!(:person) { create(:person, :SLIM) }
  let!(:practice) { create(:practice, :FINISHED, person: person, trail: trail) }
  let(:run) { create(:run, person: person, race: race) }

  # show
  describe 'GET	/people/:person_id/runs/:id' do
    let!(:path) { get person_run_path(person, run) }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_run.id).to eq run.id }
  end

  # new
  describe 'GET	/people/:person_id/runs/new' do
    let!(:path) { get new_person_run_path(person) }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_run.id).to be_nil }
  end

  # create
  describe 'POST /people/:person_id/runs' do
    let(:new_run_params) {{
      person_id: person.id,
      race_id: race.id
    }}

    context 'when person is eligible' do
      let!(:path) { post person_runs_path(person), params: { run: new_run_params } }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to person_path(person) }
      it { expect(Run.all.count).to eq 1 }
    end

    context 'when person has ongoing practice' do
      let!(:practice2) { create(:practice, :STARTED, person: person, trail: trail) }
      let!(:path) { post person_runs_path(person), params: { run: new_run_params } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template :new }
      it { expect(actual_run.errors.messages_for(:person_id)).not_to be_empty }
    end
  end

  # update
  describe 'PUT	/people/:person_id/runs/:id' do
    let(:run_params) {{ status: :FINISHED }}

    context 'when run successfully updates' do
      let!(:path) { put person_run_path(person, run), params: { run: run_params } }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to person_run_path(person, run) }
      it { expect(actual_run.status).to eq 'FINISHED' }
    end

    context 'when run fails to update' do
      before do
        allow(Run).to receive(:update).and_return(false)
      end

      let!(:path) { put person_run_path(person, run), params: { run: run_params } }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to person_run_path(person, run) }
    end
  end
end
