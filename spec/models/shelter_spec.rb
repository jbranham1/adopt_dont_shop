require 'rails_helper'

describe Shelter, type: :model do
  before :each do
    @shelter1 = create(:shelter, id: 1)
    @shelter2 = create(:shelter, id: 2, name: "A Shelter")
    @pet1 = create(:pet, id: 1, shelter_id: 1)
    @application = create(:application, id: 1, status: :pending)
    @application2 = create(:application, id: 2, status: :approved)
    @application_pets = create(:application_pet, application_id: 1, pet_id: 1)
    @application_pets2 = create(:application_pet, application_id: 2, pet_id: 1, status: :approved)
  end

  describe 'relationships' do
    it { should have_many :pets }
  end

  describe 'validations' do
    it { should validate_uniqueness_of :name }
  end

  describe "instance methods" do
    describe "#by_reverse_alphabetical" do
      it 'returns shelters in reverse alphabetical' do
        expect(Shelter.by_reverse_alphabetical.to_a).to eq([@shelter1, @shelter2])
      end
    end
    describe "#shelter_with_name_and_address" do
      it 'returns only the shelter name and address' do
        #expect(Shelter.shelter_with_name_and_address(1).name).to eq([@shelter1])
      end
    end
    describe "#pending_shelters" do
      it 'find if pet has any approved applications' do
        expect(Shelter.shelters_with_pending_applications).to eq([@shelter1])
      end
    end
  end
end
