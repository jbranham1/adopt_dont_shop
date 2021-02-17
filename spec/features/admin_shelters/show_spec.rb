require 'rails_helper'

RSpec.describe 'Admin Shelter show page' do
  before :each do
    ApplicationPet.destroy_all
    Pet.destroy_all
    Shelter.destroy_all
    Application.destroy_all
    @shelter1 = create(:shelter, id: 1)
    create(:pet, id: 1, shelter_id: 1)
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
