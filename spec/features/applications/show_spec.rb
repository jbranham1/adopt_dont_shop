require 'rails_helper'

RSpec.describe 'Application show page' do
  before :each do
    ApplicationPet.destroy_all
    Pet.destroy_all
    Shelter.destroy_all
    Application.destroy_all
    shelter = create(:shelter, id: 1)
    @pet1 = create(:pet, id: 1, shelter_id: 1)
    @pet2 = create(:pet, id: 2, shelter_id: 1, name: "onyx")
    @application = create(:application, id: 1)
    @application_pets = create(:application_pet, application_id: 1, pet_id: 1)
    @application_pets2 = create(:application_pet, application_id: 1, pet_id: 2)
  end
  describe 'As a visitor' do
    describe 'When I visit an applications show page' do
      it "I see name of applicant, full address, description, names of pets, and status" do
        visit "/applications/#{@application.id}"

        expect(page).to have_content("Application for #{@application.first_name} #{@application.last_name}")
        expect(page).to have_content("Address: #{@application.address}")
        expect(page).to have_content("City: #{@application.city}")
        expect(page).to have_content("State: #{@application.state}")
        expect(page).to have_content("Zipcode: #{@application.zipcode}")
        expect(page).to have_content("Description: #{@application.description}")
        expect(page).to have_content("Pets' Names:")
        within(".nav-bar") do
          expect(page).to have_content(@pet1.name)
          expect(page).to have_content(@pet2.name)
        end
        expect(page).to have_content("Application Status: #{@application.status.titleize}")
      end

      describe "And that application has not been submitted," do
        describe "Then I see a section on the page to 'Add a Pet to this Application'" do
          ApplicationPet.destroy_all
          describe "When I fill in this field with a Pet's name and I click submit," do
            it "under the search bar I see any Pet whose name matches my search" do
              visit "/applications/#{@application.id}"
              within("section") do
                expect(page).to have_content("Add a Pet to this Application")
                expect(page).to have_content("Pet name")
                expect(page).to have_button("Search")
                fill_in('pet_name', with: 'Daisy')
                click_on('Search')

                expect(page).to have_content("Daisy")
              end
            end
            it "when I click Adopt this Pet it adds the pet to the application" do
              visit "/applications/#{@application.id}"
              within("section") do
                fill_in('pet_name', with: 'Daisy')
                click_on('Search')

                expect(page).to have_content("Daisy")
                expect(page).to have_button("Adopt this Pet")
                click_on("Adopt this Pet")
              end
              within(".nav-bar") do
                expect(page).to have_content(@pet1.name)
              end
            end
          end
          describe "When I search for Pets by name," do
            it "Then I see any pet whose name PARTIALLY matches my search" do
              visit "/applications/#{@application.id}"
              within("section") do
                expect(page).to have_content("Add a Pet to this Application")
                expect(page).to have_content("Pet name")
                expect(page).to have_button("Search")
                fill_in('pet_name', with: 'ais')
                click_on('Search')

                expect(page).to have_content("Daisy")
              end
            end
          end
          it "Then my search is case insensitive" do
            visit "/applications/#{@application.id}"
            within("section") do
              expect(page).to have_content("Add a Pet to this Application")
              expect(page).to have_content("Pet name")
              expect(page).to have_button("Search")
              fill_in('pet_name', with: 'DAISY')
              click_on('Search')

              expect(page).to have_content("Daisy")
            end
          end
        end
      end
      describe "And that application has been submitted," do
        it "does not show the search for pets" do
          application = create(:application, id: 2, status: :pending)
          visit "/applications/#{application.id}"
            expect(page).to_not have_content("Add a Pet to this Application")
            expect(page).to_not have_content("Pet name")
            expect(page).to_not have_button("Search")
        end
      end
    end
    describe "And I have added one or more pets to the application" do
      describe "I see a section to submit my applicaiton" do
        describe "And I can add a description and click submit application" do
          it "changes the status to pending and no longer shows a section to add more pets" do
            visit "/applications/#{@application.id}"
            within("#submittion") do
              expect(page).to have_content("Why I would make a good owner for these pet(s):")
              fill_in('description', with: '#1 dog mom')
              click_on('Submit')

            end
            expect(current_path).to eq("/applications/#{@application.id}")
            expect(page).to_not have_content("Add a Pet to this Application")
            expect(page).to_not have_content("Pet name")
            expect(page).to_not have_button("Search")
            expect(page).to have_content("Status: Pending")
          end
        end
      end
    end
    describe "And I have not added any pets to the application" do
      it "Then I do not see a section to submit my application" do
        ApplicationPet.destroy_all
        visit "/applications/#{@application.id}"

        expect(current_path).to eq("/applications/#{@application.id}")
        expect(page).to_not have_content("Why I would make a good owner for these pet(s):")
        expect(page).to_not have_button("Submit")
      end
    end
  end
end
