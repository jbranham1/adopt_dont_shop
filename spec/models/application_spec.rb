require 'rails_helper'

describe Application, type: :model do
  before :each do
    ApplicationPet.destroy_all
    Pet.destroy_all
    Application.destroy_all
    Shelter.destroy_all

    shelter1 = create(:shelter, id: 1)
    @pet1 = create(:pet, id: 1, shelter_id: 1)
    @pet2 = create(:pet, id: 2, shelter_id: 1, name: "onyx", approximate_age: 4)
    @application = create(:application, id: 1, status: :pending)
    application_pets = create(:application_pet, application_id: 1, pet_id: 1)
    application_pets3 = create(:application_pet, application_id: 1, pet_id: 2)

  end
  describe 'relationships' do
    it {should have_many(:application_pets)}
    it {should have_many(:pets).through(:application_pets)}

  end
  describe 'validations' do
    it {should validate_presence_of :first_name}
    it {should validate_presence_of :last_name}
    it {should validate_numericality_of(:zipcode).is_greater_than_or_equal_to(0)}

    it 'status can be in_progress by default' do
      application = Application.create!(first_name: 'Jenny', last_name: 'Branham',
                                        address: '123 Adoption Ln.', city: 'Denver',
                                        state: 'CO', zipcode: 80222,
                                        description: 'description of application')
      expect(application.status).to eq('in_progress')
      expect(application.in_progress?).to eq(true)
      expect(application.pending?).to eq(false)
      expect(application.approved?).to eq(false)
      expect(application.rejected?).to eq(false)
    end

    it 'status can be pending' do
      application = Application.create!(first_name: 'Jenny', last_name: 'Branham',
                                        address: '123 Adoption Ln.', city: 'Denver',
                                        state: 'CO', zipcode: 80222,
                                        description: 'description of application', status: 'pending')
      expect(application.status).to eq('pending')
      expect(application.in_progress?).to eq(false)
      expect(application.pending?).to eq(true)
      expect(application.approved?).to eq(false)
      expect(application.rejected?).to eq(false)
    end

    it 'status can be approved' do
      application = Application.create!(first_name: 'Jenny', last_name: 'Branham',
                                        address: '123 Adoption Ln.', city: 'Denver',
                                        state: 'CO', zipcode: 80222,
                                        description: 'description of application', status: 'approved')
      expect(application.status).to eq('approved')
      expect(application.in_progress?).to eq(false)
      expect(application.pending?).to eq(false)
      expect(application.approved?).to eq(true)
      expect(application.rejected?).to eq(false)
    end

    it 'status can be rejected' do
      application = Application.create!(first_name: 'Jenny', last_name: 'Branham',
                                        address: '123 Adoption Ln.', city: 'Denver',
                                        state: 'CO', zipcode: 80222,
                                        description: 'description of application', status: 'rejected')
      expect(application.status).to eq('rejected')
      expect(application.in_progress?).to eq(false)
      expect(application.pending?).to eq(false)
      expect(application.approved?).to eq(false)
      expect(application.rejected?).to eq(true)
    end
  end

  describe "instance methods" do
    describe "#update_pet_adoption_status" do
      it "update pet adoption status on application" do
        @application.update_pet_adoption_status
        expect(@application.pets.all?(&:adoptable)).to eq (false)
      end
    end

  end
end
