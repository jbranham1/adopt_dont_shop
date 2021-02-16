require 'rails_helper'

RSpec.describe 'Admin Shelters index page' do
  before :each do
    @shelter1 = create(:shelter, id: 1, name: "A Shelter")
    @shelter2 = create(:shelter, id: 2)
    @pet1 = create(:pet, id: 1, shelter_id: 1)
    @pet2 = create(:pet, id: 2, shelter_id: 2, name: "onyx")
    @application = create(:application, id: 1, status: :pending)
    @application2 = create(:application, id: 2, status: :pending)
    @application_pets = create(:application_pet, application_id: 1, pet_id: 1)
    @application_pets2 = create(:application_pet, application_id: 2, pet_id: 2)
  end

  describe "As a visitor" do
    describe "When I visit the admin shelter index ('/admin/shelters')" do
      it "displays names of all shelters in reverse alphabetical" do
        visit '/admin/shelters'
        expect(page).to have_link(@shelter1.name)
        expect(page).to have_link(@shelter2.name)
        expect(@shelter2.name).to appear_before(@shelter1.name)
      end

      describe "Then I see a section for 'Shelters with Pending Applications'" do
        it "And in this section I see the name of every shelter that has a pending application" do
          visit '/admin/shelters'

          within("#section-pending") do
            expect(page).to have_content("Shelters with Pending Applications")
            expect(page).to have_content(@shelter1.name)
            expect(page).to have_content(@shelter2.name)
          end
        end
        it "And the shelters with pending applications are in alphabetical order" do
          visit '/admin/shelters'

          within("#section-pending") do
            expect(@shelter1.name).to appear_before(@shelter2.name)
          end
        end
      end
    end
  end
end
