require 'rails_helper'

describe Pet, type: :model do
  before :each do
    ApplicationPet.destroy_all
    Pet.destroy_all
    Shelter.destroy_all
  end

  describe 'relationships' do
    it { should belong_to :shelter }
    it {should have_many(:application_pets)}
    it { should have_many(:applications).through(:application_pets)}

  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :sex}
    it {should validate_numericality_of(:approximate_age).is_greater_than_or_equal_to(0)}

    it 'is created as adoptable by default' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
      expect(pet.adoptable).to eq(true)
    end

    it 'can be created as not adoptable' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(adoptable: false, name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
      expect(pet.adoptable).to eq(false)
    end

    it 'can be male' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(sex: :male, name: "Fluffy", approximate_age: 3, description: 'super cute')
      expect(pet.sex).to eq('male')
      expect(pet.male?).to be(true)
      expect(pet.female?).to be(false)
    end

    it 'can be female' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(sex: :female, name: "Fluffy", approximate_age: 3, description: 'super cute')
      expect(pet.sex).to eq('female')
      expect(pet.female?).to be(true)
      expect(pet.male?).to be(false)
    end
  end

  describe "class methods" do
    describe "::find_by_name" do
      it 'find pets with name' do
        shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
        pet1 = shelter.pets.create!(sex: :female, name: "Fluffy", approximate_age: 3, description: 'super cute')
        pet2 = shelter.pets.create!(sex: :female, name: "Daisy", approximate_age: 3, description: 'super cute')
        expect(Pet.find_by_name('Fluffy')).to eq([pet1])
      end
    end
  end
  describe "instance methods" do
    describe "#approved?" do
      it 'find if pet has any approved applications' do
        shelter = create(:shelter, id: 1)
        @pet1 = create(:pet, id: 1, shelter_id: 1)
        @application = create(:application, id: 1, status: :pending)
        @application2 = create(:application, id: 2, status: :approved)
        @application_pets = create(:application_pet, application_id: 1, pet_id: 1)
        @application_pets2 = create(:application_pet, application_id: 2, pet_id: 1, status: :approved)

        expect(@pet1.approved_application?).to eq(true)
      end
    end
  end
end
