require 'rails_helper'

RSpec.describe 'PeopleController', type: :request do
  before :each do
    @expected_person = create(:person)
    @expected_params = @expected_person.attributes
  end

  # index
  describe 'GET /people' do
    it 'works!' do
      get people_path

      actual_people = assigns(:people)

      expect(response).to have_http_status(:ok)
      expect(actual_people.count).to eq 1
    end

    it 'retrieves all People' do
      2.times { create(:person) }

      get people_path
      actual_people = assigns(:people)

      expect(response).to have_http_status(:ok)
      expect(actual_people).not_to be_empty
      expect(actual_people.count).to eq 3
    end
  end

  # show
  describe 'GET /people/:id' do
    it 'retrieves the correct Person' do
      get person_path(@expected_person.id)
      actual_person = assigns(:person)

      expect(response).to have_http_status(:ok)
      expect(actual_person.name).to eq @expected_person.name
    end
  end

  # new
  describe 'GET /people/new' do
    it 'instantiates a new Person' do
      get new_person_path
      actual_person = assigns(:person)

      expect(response).to have_http_status(:ok)
      expect(actual_person.name).to be_nil
    end
  end

  # create
  describe 'POST /people' do
    it 'creates a new Person with valid parameters' do
      new_person_params = attributes_for(:person)

      post people_path, params: { person: new_person_params }
      actual_person = assigns(:person)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to person_path(actual_person.id)
      expect(actual_person.name).to eq new_person_params[:name]
    end

    it 'does not create with invalid parameters' do
      new_person_params = attributes_for(:person)
      new_person_params[:body_build] = nil

      post people_path, params: { person: new_person_params }
      actual_person = assigns(:person)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template :new
      expect(actual_person.errors).not_to be_empty
    end
  end

  # edit
  describe 'GET /people/:id/edit' do
    it 'retrieves correct Person for editing' do
      get edit_person_path(@expected_person.id)
      actual_person = assigns(:person)

      expect(response).to have_http_status(:ok)
      expect(actual_person.name).to eq @expected_person.name
    end
  end

  # update
  describe 'PUT /people/:id' do
    it 'updates a Person with valid parameters' do
      new_weight = @expected_person.weight + 5
      @expected_params[:weight] = new_weight

      put person_path(@expected_person.id), params: { person: @expected_params }
      actual_person = assigns(:person)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to person_path(actual_person.id)
      expect(actual_person.weight).to eq new_weight
    end

    it 'does not update with invalid parameters' do
      @expected_params[:weight] = nil

      put person_path(@expected_person.id), params: { person: @expected_params }
      actual_person = assigns(:person)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template :edit
      expect(actual_person.errors).not_to be_empty
    end
  end

  # destroy
  describe 'DELETE /people/:id' do
    it 'deletes a Person' do
      delete person_path(@expected_person.id)

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to people_path
      expect(Person.all).to be_empty
    end
  end
end
