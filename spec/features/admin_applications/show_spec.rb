require 'rails_helper'

RSpec.describe 'Admin Application show page' do
  before :each do
    ApplicationPet.destroy_all
    Pet.destroy_all
    Shelter.destroy_all
    Application.destroy_all
    shelter = create(:shelter, id: 1)
    @pet1 = create(:pet, id: 1, shelter_id: 1)
    @pet2 = create(:pet, id: 2, shelter_id: 1, name: "onyx")
    @application = create(:application, id: 1, status: :pending)
    @application_pets = create(:application_pet, application_id: 1, pet_id: 1)
    @application_pets2 = create(:application_pet, application_id: 1, pet_id: 2)
  end
  describe 'As a visitor' do
    describe "When I visit an admin application show page ('/admin/applications/:id')" do
      describe "For every pet that the application is for, I see a button to approve the application for that specific pet" do
        describe "When I click that button then I'm taken back to the admin application show page" do
          it "next to the pet that I approved, I do not see a button to approve this pet,instead I see an indicator next to the pet that they have been approved" do
            visit "/admin/applications/#{@application.id}"
            within "#pet-#{@pet1.id}" do
              expect(page).to have_content(@pet1.name)
              expect(page).to have_button("Approve Pet")
              click_button "Approve Pet"

              expect(page).to_not have_button("Approve Pet")
              expect(page).to have_content("Approved!")
            end
            within "#pet-#{@pet2.id}" do
              expect(page).to have_content(@pet2.name)
              expect(page).to have_button("Approve Pet")
            end
          end
        end
      end
      describe "For every pet that the application is for, I see a button to reject the application for that specific pet" do
        describe "When I click that button then I'm taken back to the admin application show page" do
          it "next to the pet that I rejected, I do not see a button to reject or approve this pet,instead I see an indicator next to the pet that they have been rejected" do
            visit "/admin/applications/#{@application.id}"
            within "#pet-#{@pet1.id}" do
              expect(page).to have_content(@pet1.name)
              expect(page).to have_button("Reject Pet")
              click_button "Reject Pet"

              expect(page).to_not have_button("Reject Pet")
              expect(page).to have_content("Rejected!")
            end
            within "#pet-#{@pet2.id}" do
              expect(page).to have_content(@pet2.name)
              expect(page).to have_button("Reject Pet")
            end
          end
        end
        describe "When there are two applications in the system for the same pet" do
          describe "When I visit the admin application show page for one of the applications and I approve or reject the pet for that application" do
            describe "When I visit the other application's admin show page" do
              it "Then I do not see that the pet has been accepted or rejected for that application And instead I see buttons to approve or reject the pet for this specific application" do
                visit "/admin/applications/#{@application.id}"
                within "#pet-#{@pet1.id}" do
                  expect(page).to have_content('Daisy')
                  expect(page).to have_button("Reject Pet")
                  click_button "Reject Pet"

                  expect(page).to_not have_button("Reject Pet")
                  expect(page).to have_content("Rejected!")
                end
                application2 = create(:application, id: 2)
                application_pets3 = create(:application_pet, application_id: 2, pet_id: 1)

                visit "/admin/applications/#{application2.id}"
                within "#pet-#{application_pets3.pet.id}" do
                  expect(page).to have_content('Daisy')
                  expect(page).to have_button("Approve Pet")
                  expect(page).to have_button("Reject Pet")
                end
              end
            end
          end
        end
      end
      describe "And I approve all pets for an application" do
        it "The application status will change to 'Approved'" do
          visit "/admin/applications/#{@application.id}"
          expect(page).to have_content("Application Status: Pending")
          within "#pet-#{@pet1.id}" do
            click_button "Approve Pet"
          end
          within "#pet-#{@pet2.id}" do
            click_button "Approve Pet"
          end
          expect(page).to have_content("Application Status: Approved")
        end
      end
      describe "And I don't approve all pets for an application" do
        it "The application status will change to 'Rejected'" do
          visit "/admin/applications/#{@application.id}"
          expect(page).to have_content("Application Status: Pending")
          within "#pet-#{@pet1.id}" do
            click_button "Approve Pet"
          end
          expect(page).to have_content("Application Status: Rejected")
        end
      end
    end
  end
end
