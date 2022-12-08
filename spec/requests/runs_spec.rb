require 'rails_helper'

RSpec.describe "Runs", type: :request do
  let!(:trail) { create(:trail, :SLIM) }
  let!(:race) { create(:race, trail: trail) }
  let!(:person) { create(:person, :SLIM) }
  let!(:practice) { create(:practice, :FINISHED, person: person, trail: trail) }

  # show
  describe 'GET	/people/:person_id/runs/:id' do
    let!(:run) { create(:run, person: person, race: race) }

    it 'shows the correct run' do
      get person_run_path(person, run)
      actual_run = assigns(:run)

      expect(response).to have_http_status(:ok)
      expect(actual_run.id).to eq run.id
    end
  end

  # new
  describe 'GET	/people/:person_id/runs/new' do
    it 'instantiates a new Race' do
      get new_person_run_path(person)
      actual_run = assigns(:run)

      expect(response).to have_http_status(:ok)
      expect(actual_run.id).to be_nil
    end
  end

  # create
  describe 'POST /people/:person_id/runs' do
    context 'when person is eligible' do
      it 'creates a new Run' do
        new_run_params = {
          person_id: person.id,
          race_id: race.id
        }

        post person_runs_path(person), params: { run: new_run_params }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to person_path(person)
        expect(Run.all.count).to eq 1
      end
    end

    context 'when person is unavailable' do
      let!(:practice2) { create(:practice, :STARTED, person: person, trail: trail) }

      it 'shows an error and redirects' do
        new_run_params = {
          person_id: person.id,
          race_id: race.id
        }

        post person_runs_path(person), params: { run: new_run_params }
        actual_run = assigns(:run)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template :new
        expect(actual_run.errors.messages_for(:person_id)).not_to be_empty
      end
    end
  end

  # update
  describe 'PUT	/people/:person_id/runs/:id' do
    let!(:run) { create(:run, person: person, race: race) }

    it 'changes the status' do
      new_run_params = {
        status: :FINISHED
      }

      put person_run_path(person, run), params: { run: new_run_params }
      actual_run = assigns(:run)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to person_run_path(person, run)
      expect(actual_run.status).to eq 'FINISHED'
    end
  end
end
