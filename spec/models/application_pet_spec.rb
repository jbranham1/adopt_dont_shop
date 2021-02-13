require 'rails_helper'

describe ApplicationPet, type: :model do
  describe 'relationships' do
    it { should belong_to :application }
    it { should belong_to :pet }
  end

  describe 'validations' do
    ApplicationPet.destroy_all
    Pet.destroy_all
    Shelter.destroy_all
    Application.destroy_all

    shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
    pet = shelter.pets.create!(name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
    application = Application.create!(first_name: 'Jenny', last_name: 'Branham',
                                      address: '123 Adoption Ln.', city: 'Denver',
                                      state: 'CO', zipcode: '80222',
                                      description: 'description of application', status: 'in_progress')
    ApplicationPet.create!(application_id: application.id, pet_id: pet.id)

    it {should validate_presence_of :application_id}
    it {should validate_presence_of :pet_id}
  end
end