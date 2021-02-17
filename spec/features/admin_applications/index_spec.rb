require 'rails_helper'

RSpec.describe 'Admin Applications index page' do
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
    describe "When I visit the admin application index ('/admin/applications')" do
      it "displays names of all application" do
        visit '/admin/applications'
        expect(page).to have_link("#{@application.first_name} #{@application.last_name}")
        expect(page).to have_link("#{@application2.first_name} #{@application2.last_name}")
      end
    end
  end
end
