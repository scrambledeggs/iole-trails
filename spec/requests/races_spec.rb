require 'rails_helper'

RSpec.describe "RacesController", type: :request do
  let!(:trail) { create(:trail) }
  let!(:expected_race) { create(:race, trail: trail) }

  # index
  describe 'GET /trails/:trail_id/races' do
    it 'works!' do
      get trail_races_path(trail)
      actual_races = assigns(:races)

      expect(response).to have_http_status(:ok)
      expect(actual_races.count).to eq 1
    end

    it 'retrieves all Races for the Trail' do
      2.times { create(:race, trail: trail) }

      get trail_races_path(trail)
      actual_races = assigns(:races)

      expect(response).to have_http_status(:ok)
      expect(actual_races).not_to be_empty
      expect(actual_races.count).to eq 3
    end
  end

  # show
  describe 'GET /trails/:trail_id/races/:id' do
    context 'the race is not finished' do
      it 'retrieves the correct Race' do
        get trail_race_path(trail, expected_race)
        actual_race = assigns(:race)

        expect(response).to have_http_status(:ok)
        expect(actual_race.name).to eq expected_race.name
      end
    end

    context 'the race has finished' do
      it 'retrieves the correct Race and winner' do
        trail1 = create(:trail, :SLIM)
        person1 = create(:person, :SLIM)
        person2 = create(:person, :SLIM)
        practice1 = create(:practice, :FINISHED, person: person1, trail: trail1)
        practice2 = create(:practice, :FINISHED, person: person2, trail: trail1)
        race1 = create(:race, :with_winner, trail: trail1)
        run1 = create(:run, :with_finished_stats, person: person1, race: race1, id: 1)
        run2 = create(:run, :with_unfinished_stats, person: person2, race: race1, id: 2)

        get trail_race_path(trail1, race1)
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
    it 'instantiates a new Race' do
      get new_trail_race_path(trail)
      actual_race = assigns(:race)

      expect(response).to have_http_status(:ok)
      expect(actual_race.name).to be_nil
    end
  end

  # create
  describe 'POST /trails/:trail_id/races' do
    it 'creates a new Race with valid parameters' do
      new_race_params = attributes_for(:race)

      post trail_races_path(trail), params: { race: new_race_params }
      actual_race = assigns(:race)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to trail_race_path(trail, actual_race)
      expect(actual_race.name).to eq new_race_params[:name]
    end

    it 'does not create with invalid parameter' do
      new_race_params = attributes_for(:race)
      new_race_params[:name] = nil

      post trail_races_path(trail), params: { race: new_race_params }
      actual_race = assigns(:race)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template :new
      expect(actual_race.errors).not_to be_empty
    end

    it 'does not create overlapping races within the same trail' do
      new_race_params = attributes_for(:race)
      new_race_params[:start] = expected_race.start

      post trail_races_path(trail), params: { race: new_race_params }
      actual_race = assigns(:race)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template :new
      expect(actual_race.errors).not_to be_empty
    end
  end

  # edit
  describe 'GET /trails/:trail_id/races/:id/edit' do
    it 'retrieves correct Race for editing' do
      get edit_trail_race_path(trail, expected_race)
      actual_race = assigns(:race)

      expect(response).to have_http_status(:ok)
      expect(actual_race.name).to eq expected_race.name
    end
  end

  # update
  describe 'PUT /trails/:trail_id/races/:id' do
    it 'updates a new Race with valid parameters' do
      new_duration = expected_race.duration + 1
      expected_params = { duration: new_duration }

      put trail_race_path(trail, expected_race), params: { race: expected_params }
      actual_race = assigns(:race)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to trail_race_path(trail, actual_race)
      expect(actual_race.duration).to eq new_duration
    end

    it 'does not update with invalid parameter' do
      expected_params = { duration: nil }

      put trail_race_path(trail, expected_race), params: { race: expected_params }
      actual_race = assigns(:race)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template :edit
      expect(actual_race.errors).not_to be_empty
    end

    pending 'does not update status with less than 2 participants'
    # it 'does not update status with less than 2 participants' do
    #   expected_params = { status: :STARTED }

    #   put trail_race_path(trail, expected_race), params: { race: expected_params }
    #   actual_race = assigns(:race)

    #   expect(response).to have_http_status(:conflict)
    #   expect(response).to redirect_to trail_race_path(trail, actual_race)
    #   expect(actual_race.errors).not_to be_empty
    # end
  end

  # destroy
  describe 'DELETE /trails/:trail_id/races/:id' do
    it 'deletes a Race' do
      delete trail_race_path(trail, expected_race)

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to trail_races_path(trail)
      expect(Race.all).to be_empty
    end
  end

  # # all
  # describe 'GET /races' do
  #   it 'retrieves all Races' do
  #     trail2 = create(:trail)
  #     race2 = create(:race, trail: trail2)

  #     get races_path
  #     actual_races = assigns(:races)

  #     expect(response).to have_http_status(:ok)
  #     expect(actual_races.count).to eq 2
  #   end
  # end
end
