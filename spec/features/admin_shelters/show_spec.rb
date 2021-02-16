require 'rails_helper'

RSpec.describe 'Admin Shelter show page' do
  before :each do
    @shelter1 = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
  end
  describe "As a visitor" do
    it "displays shelter with that id and all its attributes" do
      visit "/admin/shelters/#{@shelter1.id}"

      expect(page).to have_content(@shelter1.name)
      expect(page).to have_content(@shelter1.address)
      expect(page).to have_content(@shelter1.city)
      expect(page).to have_content(@shelter1.state)
      expect(page).to have_content(@shelter1.zip)
    end
    describe "When I visit the admin shelter index and click on shelter link" do
      it "Then I am taken to that shelter's admin show page" do
        visit "/admin/shelters"
        click_link("Shady Shelter")

        expect(current_path).to eq("/admin/shelters/#{@shelter1.id}")
      end
    end
  end
end
