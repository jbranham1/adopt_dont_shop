require 'rails_helper'

describe Shelter, type: :model do
  before :each do
    ApplicationPet.destroy_all
    Pet.destroy_all
    Application.destroy_all
    Shelter.destroy_all

    @shelter1 = create(:shelter, id: 1)
    @shelter2 = create(:shelter, id: 2, name: "A Shelter")
    pet1 = create(:pet, id: 1, shelter_id: 1)
    pet2 = create(:pet, id: 2, shelter_id: 1, name: "onyx", approximate_age: 4)
    pet3 = create(:pet, id: 3, shelter_id: 2, name: "fluffy", approximate_age: 4)
    application = create(:application, id: 1, status: :pending)
    application2 = create(:application, id: 2, status: :approved)
    application_pets = create(:application_pet, application_id: 1, pet_id: 1)
    application_pets2 = create(:application_pet, application_id: 2, pet_id: 1, status: :approved)
    application_pets3 = create(:application_pet, application_id: 1, pet_id: 2)
  end

  describe 'relationships' do
    it { should have_many :pets }
  end

  describe 'validations' do
    it { should validate_uniqueness_of :name }
  end

  describe "class methods" do
    describe "::by_reverse_alphabetical" do
      it 'returns shelters in reverse alphabetical' do
        expect(Shelter.by_reverse_alphabetical.to_a).to eq([@shelter1, @shelter2])
      end
    end
    describe "::shelter_with_name_and_address" do
      it 'returns only the shelter name and address' do
        expect(Shelter.shelter_with_name_and_address(1).first.name).to eq(@shelter1.name)
        expect(Shelter.shelter_with_name_and_address(1).first.id).to eq(nil)
      end
    end
    describe "::pending_shelters" do
      it 'find if pet has any approved applications' do
        expect(Shelter.shelters_with_pending_applications).to eq([@shelter1])
      end
    end
  end

  describe "instance methods" do
    describe "#average_age_for_adoptable_pets" do
      it "gets the average age of all adoptable pets for this shelter" do
        expect(@shelter1.average_age_for_adoptable_pets).to eq (3.5)
      end
    end
  end
end
