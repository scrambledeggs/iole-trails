require 'rails_helper'

RSpec.describe 'PracticesController', type: :request do
  subject(:actual_practice) { assigns(:practice) }

  let!(:person) { create(:person, :SLIM) }
  let!(:trail) { create(:trail, :SLIM) }
  let(:practice) { create(:practice, person: person, trail: trail) }

  # new
  describe 'GET /people/:person_id/practices/new' do
    let!(:path) { get new_person_practice_path(person) }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_practice.trail).to be_nil }
  end

  # create
  describe 'POST /people/:person_id/practices' do
    let!(:path) {
      post person_practices_path(person), params: {
        practice: {
          trail_id: trail_id,
          person_id: person.id
        }}}

    context 'when person is eligible' do
      let(:trail_id) { trail.id }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to person_path(person) }
    end

    context 'when person is ineligible' do
      let(:trail2) { create(:trail, :FIT) }
      let(:trail_id) { trail2.id }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template :new }
      it { expect(actual_practice.errors.messages_for(:person_id)).not_to be_empty }
    end
  end

  # update
  describe 'PUT /people/:person_id/practices/:id' do
    let!(:path) { put person_practice_path(person, practice), params: { practice: practice_params } }
    let(:practice_params) { {
      status: :FINISHED
    } }

    context 'when updating status to FINISHED' do
      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to person_path(person) }
      it { expect(actual_practice.status).to eq 'FINISHED' }
    end

    # TODO: it renders edit again
  end
end
