require 'rails_helper'

RSpec.describe "TrailsController", type: :request do
  let!(:expected_trail) { create(:trail, :for_heavy) }

  # index
  describe 'GET /trails' do
    it 'works!' do
      get trails_path
      actual_trails = assigns(:trails)

      expect(response).to have_http_status(:ok)
      expect(actual_trails.count).to eq 1
    end

    it 'retrieves all trails' do
      2.times { create(:trail) }

      get trails_path
      actual_trails = assigns(:trails)

      expect(response).to have_http_status(:ok)
      expect(actual_trails).not_to be_empty
      expect(actual_trails.count).to eq 3
    end
  end

  # show
  describe 'GET /trails/:id' do
    it 'retrieves the correct trail' do
      get trail_path(expected_trail)
      actual_trail = assigns(:trail)

      expect(response).to have_http_status(:ok)
      expect(actual_trail.name).to eq expected_trail.name
    end
  end

  # new
  describe 'GET /trails/new' do
    it 'instantiates a new Trail' do
      get new_trail_path
      actual_trail = assigns(:trail)

      expect(response).to have_http_status(:ok)
      expect(actual_trail.name).to be_nil
    end
  end

  # create
  describe 'POST /trails' do
    it 'creates a new Trail with valid parameters' do
      new_trail_params = attributes_for(:trail)

      post trails_path, params: { trail: new_trail_params }
      actual_trail = assigns(:trail)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to trail_path(actual_trail)
      expect(actual_trail.name).to eq new_trail_params[:name]
    end

    it 'creates with minimum required parameter' do
      new_trail_params = {
        name: 'trail1'
      }

      post trails_path, params: { trail: new_trail_params }
      actual_trail = assigns(:trail)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to trail_path(actual_trail)
      expect(actual_trail.name).to eq new_trail_params[:name]
    end

    it 'does not create with invalid parameter' do
      new_trail_params = attributes_for(:trail)
      new_trail_params[:name] = nil

      post trails_path, params: { trail: new_trail_params }
      actual_trail = assigns(:trail)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template :new
      expect(actual_trail.errors).not_to be_empty
    end
  end

  # edit
  describe 'GET /trails/:id/edit' do
    it 'retrieves correct Trail for editing' do
      get edit_trail_path(expected_trail)
      actual_trail = assigns(:trail)

      expect(response).to have_http_status(:ok)
      expect(actual_trail.name).to eq expected_trail.name
    end
  end

  # update
  describe 'PUT /trails/:id' do
    it 'updates a Trail with valid parameters' do
      new_weight_maximum = expected_trail.weight_maximum + 5
      expected_params = { weight_maximum: new_weight_maximum }

      put trail_path(expected_trail), params: { trail: expected_params }
      actual_trail = assigns(:trail)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to trail_path(actual_trail)
      expect(actual_trail.weight_maximum).to eq new_weight_maximum
    end

    it 'does not update with invalid parameter' do
      expected_params = { name: nil }

      put trail_path(expected_trail), params: { trail: expected_params }
      actual_trail = assigns(:trail)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template :edit
      expect(actual_trail.errors).not_to be_empty
    end
  end

  # destroy
  describe 'DELETE /trails/:id' do
    it 'deletes a Trail' do
      delete trail_path(expected_trail)

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to trails_path
      expect(Trail.all).to be_empty
    end
  end
end