require 'rails_helper'

RSpec.describe 'TrailsController', type: :request do
  let!(:trail1) { create(:trail, :for_heavy) }
  let!(:trail2) { create(:trail) }
  let(:actual_trails) { assigns(:trails) }
  let(:actual_trail) { assigns(:trail) }

  # index
  describe 'GET /trails' do
    let!(:path) { get trails_path }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_trails.count).to eq 2 }
  end

  # show
  describe 'GET /trails/:id' do
    let!(:path) { get trail_path(trail1) }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_trail.name).to eq trail1.name }
  end

  # new
  describe 'GET /trails/new' do
    let!(:path) { get new_trail_path }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_trail.name).to be_nil }
  end

  # create
  describe 'POST /trails' do
    let!(:path) { post trails_path, params: { trail: new_trail_params } }

    context 'when creating with valid parameters' do
      let!(:new_trail_params) { attributes_for(:trail) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to trail_path(actual_trail) }
      it { expect(actual_trail.name).to eq new_trail_params[:name] }
    end

    context 'when creating with minimum required parameter' do
      let!(:new_trail_params) {{ name: 'Trail1' }}

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to trail_path(actual_trail) }
      it { expect(actual_trail.name).to eq new_trail_params[:name] }
      it { expect(actual_trail.age_minimum).to be_nil }
    end

    context 'when creating with invalid required parameter' do
      let!(:new_trail_params) {{ name: nil }}

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template :new }
      it { expect(actual_trail.errors.messages_for(:name)).not_to be_empty }
    end
  end

  # edit
  describe 'GET /trails/:id/edit' do
    let!(:path) { get edit_trail_path(trail1) }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_trail.name).to eq trail1.name }
  end

  # update
  describe 'PUT /trails/:id' do
    let!(:path) { put trail_path(trail1), params: { trail: expected_params } }

    context 'when updating with valid parameters' do
      let(:new_weight_maximum) { trail1.weight_maximum + 5 }
      let!(:expected_params) {{ weight_maximum: new_weight_maximum }}

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to trail_path(actual_trail) }
      it { expect(actual_trail.weight_maximum).to eq new_weight_maximum }
    end

    context 'when updating with invalid parameter' do
      let!(:expected_params) {{ name: nil }}

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template :edit }
      it { expect(actual_trail.errors.messages_for(:name)).not_to be_empty }
    end
  end

  # destroy
  describe 'DELETE /trails/:id' do
    let!(:path) { delete trail_path(trail1) }

    it { expect(response).to have_http_status(:see_other) }
    it { expect(response).to redirect_to trails_path }
    it { expect(Trail.all.count).to eq 1 }
  end
end
