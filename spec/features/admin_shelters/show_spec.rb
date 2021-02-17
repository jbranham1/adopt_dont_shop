require 'rails_helper'

RSpec.describe 'Admin Shelter show page' do
  before :each do
    ApplicationPet.destroy_all
    Pet.destroy_all
    Shelter.destroy_all
    Application.destroy_all
    @shelter1 = create(:shelter, id: 1)
    @pet1 = create(:pet, id: 1, shelter_id: 1)
    create(:pet, id: 2, shelter_id: 1, name: "onyx", approximate_age: 4)
  end
  describe "As a visitor" do
    describe "When I visit the admin shelter show page" do
      it "displays shelter with that id and all its attributes" do
        visit "/admin/shelters/#{@shelter1.id}"

        expect(page).to have_content(@shelter1.name)
        expect(page).to have_content(@shelter1.address)
        expect(page).to have_content(@shelter1.city)
        expect(page).to have_content(@shelter1.state)
        expect(page).to have_content(@shelter1.zip)
      end
      describe "Then I see a section for statistics" do
        it "And in that section I see the average age of all adoptable pets for that shelter" do
          visit "/admin/shelters/#{@shelter1.id}"
          within("#section-stats") do
            expect(page).to have_content("Average Age of All Adoptable Pets: 3.5")
          end
        end
        it "And in that section I see the count of all adoptable pets for that shelter" do
          visit "/admin/shelters/#{@shelter1.id}"
          within("#section-stats") do
            expect(page).to have_content("Count of Adoptable Pets: 2")
          end
        end
        it "And in that section I see the number of pets that have been adopted from that shelter" do
          pet3 = create(:pet, id: 3, shelter_id: 1, name: "princess")
          pet4 = create(:pet, id: 4, shelter_id: 1, name: "fluffy")
          application3 = create(:application, id: 3, status: :approved)
          application4 = create(:application, id: 4, status: :approved)
          application_pets3 = create(:application_pet, application_id: 3, pet_id: 1)
          application_pets4 = create(:application_pet, application_id: 4, pet_id: 2)
          visit "/admin/shelters/#{@shelter1.id}"
          within("#section-stats") do
            expect(page).to have_content("Count of Adopted Pets: 2")
          end
        end
      end
      describe "Then I see a section titled 'Action Required'" do
        it "In that section, I see a list of all pets for this shelter that have a pending application and have not yet been marked 'approved' or 'rejected'" do
          application = create(:application, id: 1, status: :pending)
          application_pets = create(:application_pet, application_id: 1, pet_id: 1)
          visit "/admin/shelters/#{@shelter1.id}"
          within("#section-action-required") do
            expect(page).to have_content("Action Required")
            expect(page).to have_content(@pet1.name)
          end
        end
      end

    end
    describe "When I visit the admin shelter index and click on shelter link" do
      it "Then I am taken to that shelter's admin show page" do
        visit "/admin/shelters"
        click_link("Shelter 1")

        expect(current_path).to eq("/admin/shelters/#{@shelter1.id}")
      end
    end
  end
end
