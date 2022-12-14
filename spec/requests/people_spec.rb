require 'rails_helper'

RSpec.describe 'PeopleController', type: :request do
  let!(:person1) { create(:person) }
  let!(:person2) { create(:person) }
  let(:actual_people) { assigns(:people) }
  let(:actual_person) { assigns(:person) }

  # index
  describe 'GET /people' do
    let!(:path) { get people_path }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_people.count).to eq 2 }
  end

  # show
  describe 'GET /people/:id' do
    let!(:path) { get person_path(person1) }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_person.name).to eq person1.name }
  end

  # new
  describe 'GET /people/new' do
    let!(:path) { get new_person_path }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_person.name).to be_nil }
  end

  # create
  describe 'POST /people' do
    let(:new_person_params) { attributes_for(:person, age: age) }

    context 'when creating with valid parameters' do
      let(:age) { 25 }
      let!(:path) { post people_path, params: { person: new_person_params } }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to person_path(actual_person) }
      it { expect(actual_person.name).to eq new_person_params[:name] }
    end

    context 'when creating with invalid parameters' do
      let(:age) { nil }
      let!(:path) { post people_path, params: { person: new_person_params } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template :new }
      it { expect(actual_person.errors.messages_for(:age)).not_to be_empty }
    end
  end

  # edit
  describe 'GET /people/:id/edit' do
    let!(:path) { get edit_person_path(person1) }

    it { expect(response).to have_http_status(:ok) }
    it { expect(actual_person.name).to eq person1.name }
  end

  # update
  describe 'PUT /people/:id' do
    let!(:path) { put person_path(person1), params: { person: { weight: new_weight } } }

    context 'when updating with valid parameters' do
      let(:new_weight) { person1.weight + 5 }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to person_path(actual_person) }
      it { expect(actual_person.weight).to eq new_weight }
    end

    context 'when updating with invalid parameters' do
      let(:new_weight) { nil }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response).to render_template :edit }
      it { expect(actual_person.errors.messages_for(:weight)).not_to be_empty }
    end
  end

  # destroy
  describe 'DELETE /people/:id' do
    let!(:path) { delete person_path(person1) }

    it { expect(response).to have_http_status(:see_other) }
    it { expect(response).to redirect_to people_path }
    it { expect(Person.all.count).to eq 1 }
  end
end
