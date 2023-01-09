require 'rails_helper'

RSpec.describe 'RacesController', type: :request do
  let(:actual_race) { assigns(:race) }
  let(:actual_races) { assigns(:races) }

  let!(:trail) { create(:trail, :SLIM) }
  let!(:race1) { create(:race, trail: trail) }
  let!(:race2) { create(:race, trail: trail) }

  # index
  describe 'GET /trails/:trail_id/races' do
    let!(:path) { get trail_races_path(trail) }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_races.count).to eq 2 }
  end

  # show
  describe 'GET /trails/:trail_id/races/:id' do
    context 'when the race is not finished' do
      let!(:path) { get trail_race_path(trail, race1) }

      it { expect(response).to have_http_status(:ok) }
      it { expect(actual_race.name).to eq race1.name }
    end

    context 'when the race has finished' do
      it 'retrieves the correct Race and winner' do
        race3 = create(:race, :with_winner, trail: trail)

        person1 = create(:person, :SLIM)
        person2 = create(:person, :SLIM)
        create(:practice, :FINISHED, person: person1, trail: trail)
        create(:practice, :FINISHED, person: person2, trail: trail)
        run1 = create(:run, :with_finished_stats, person: person1, race: race3, id: 1)
        run2 = create(:run, :with_unfinished_stats, person: person2, race: race3, id: 2)

        get trail_race_path(trail, race3)
        actual_winner = assigns(:winner)
        actual_winning_run = assigns(:winning_run)

        expect(response).to have_http_status(:ok)
        expect(actual_winner.name).to eq person1.name
        expect(actual_winning_run.id).to eq run1.id
      end
    end
  end

  # new
  describe 'GET /trails/:trail_id/races/new' do
    let!(:path) { get new_trail_race_path(trail) }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_race.name).to be_nil }
  end

  # create
  describe 'POST /trails/:trail_id/races' do
    let!(:path) { post trail_races_path(trail), params: { race: new_race_params } }

    context 'when creating with valid parameters' do
      let(:new_race_params) { attributes_for(:race) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to trail_race_path(trail, actual_race) }
      it { expect(actual_race.name).to eq new_race_params[:name] }
    end

    context 'when creating with invalid parameter' do
      let(:new_race_params) { attributes_for(:race, name: nil) }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template :new }
      it { expect(actual_race.errors.messages_for(:name)).not_to be_empty }
    end

    context 'when creating overlapping races within the same trail' do
      let(:new_race_params) { attributes_for(:race, start: race1.start) }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template :new }
      it { expect(actual_race.errors.messages_for(:time_period)).to match(['overlaps another race in the same trail']) }
    end
  end

  # edit
  describe 'GET /trails/:trail_id/races/:id/edit' do
    let!(:path) { get edit_trail_race_path(trail, race1) }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_race.name).to eq race1.name }
  end

  # update
  describe 'PUT /trails/:trail_id/races/:id' do
    let!(:path) { put trail_race_path(trail, race1), params: { race: expected_params } }

    context 'when updating with valid parameters' do
      let(:expected_params) { { duration: race1.duration + 1 } }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to trail_race_path(trail, actual_race) }
      it { expect(actual_race.duration).to eq expected_params[:duration] }
    end

    context 'when updating with invalid parameters' do
      let(:expected_params) { { duration: nil } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template :edit }
      it { expect(actual_race.errors.messages_for(:duration)).not_to be_empty }
    end

    context 'when starting with less than 2 participants' do
      let(:expected_params) { { status: :STARTED } }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to trail_race_path(trail, actual_race) }
      it { expect(actual_race.errors.messages_for(:status)).not_to be_empty }
    end

    context 'when updating to overlapping another race' do
      let(:expected_params) { attributes_for(:race, start: race2.start) }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template :edit }
      it { expect(actual_race.errors.messages_for(:time_period)).to match(['overlaps another race in the same trail']) }
    end
  end

  # destroy
  describe 'DELETE /trails/:trail_id/races/:id' do
    let!(:path) { delete trail_race_path(trail, race1) }

    it { expect(response).to have_http_status(:see_other) }
    it { expect(response).to redirect_to trail_races_path(trail) }
    it { expect(Race.all.count).to eq 1 }
  end

  # all
  describe 'GET /races' do
    let!(:race3) { create(:race) }
    let!(:path) { get races_path }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_races.count).to eq 3 }
  end

  # finish
  describe 'PUT /trails/:trail_id/races/:id/finish' do
    let!(:person1) { create(:person, :SLIM) }
    let!(:person2) { create(:person, :SLIM) }
    let!(:practice1) { create(:practice, :FINISHED, person: person1, trail: trail) }
    let!(:practice2) { create(:practice, :FINISHED, person: person2, trail: trail) }
    let!(:run1) { create(:run, person: person1, race: race1) }
    let!(:run2) { create(:run, person: person2, race: race1) }

    context 'when race successfully updates to finished' do
      let!(:path) { put finish_trail_race_path(trail, race1) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to trail_race_path(trail, actual_race) }
      it { expect(flash[:alert]).to be_nil }
    end

    context 'when race fails to update as finished due to runs' do
      before do
        allow(Run).to receive(:update).and_return(false)
      end

      let!(:path) { put finish_trail_race_path(trail, race1) }

      it 'should redirect' do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to trail_race_path(trail, actual_race)
        expect(flash[:alert]).to match('Could not update runs with random')
      end
    end

    context 'when race fails to update as finished' do
      before do
        allow_any_instance_of(Race).to receive(:save) do |race|
          race.errors.add(:status, 'Error message')
          false
        end
      end

      let!(:path) { put finish_trail_race_path(trail, race1) }

      it 'should redirect' do
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to trail_race_path(trail, actual_race)
        expect(flash[:alert]).to match('Status Error message')
      end
    end
  end
end
