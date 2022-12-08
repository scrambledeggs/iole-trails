require 'rails_helper'

RSpec.describe "PracticesController", type: :request do
  let!(:person) { create(:person, :SLIM) }
  let!(:trail) { create(:trail, :SLIM) }
  # new
  describe "GET /people/:person_id/practices/new" do
    it 'instantiates a new Practice' do
      get new_person_practice_path(person)
      actual_practice = assigns(:practice)

      expect(response).to have_http_status(:ok)
      expect(actual_practice.trail).to be_nil
    end
  end

  # create
  describe "POST /people/:person_id/practices" do
    it "creates a Practice for eligible people" do
      new_practice_params = {
        trail_id: trail.id,
        person_id: person.id
      }

      post person_practices_path(person), params: { practice: new_practice_params }

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to person_path(person)
    end

    it "shows an error for ineligible people" do
      trail = create(:trail, :FIT)
      new_practice_params = {
        trail_id: trail.id,
        person_id: person.id
      }

      post person_practices_path(person), params: { practice: new_practice_params }
      actual_practice = assigns(:practice)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template :new
      expect(actual_practice.errors).not_to be_empty
    end
  end

  # update
  describe "PUT /people/:person_id/practices/:id" do
    it "updates the status to FINISHED" do
      practice = create(:practice, person: person, trail: trail)
      new_practice_params = {
        person_id: person.id, # TODO: update in model?
        status: :FINISHED
      }

      put person_practice_path(person, practice), params: { practice: new_practice_params }
      actual_practice = assigns(:practice)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to person_path(person)
      expect(actual_practice.status).to eq 'FINISHED'
    end
  end

  # TODO: it renders edit again
end
