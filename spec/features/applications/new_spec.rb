require 'rails_helper'

RSpec.describe 'Application new page' do
  it 'can create a new application from the pet index page' do
    visit '/pets'

    click_link 'Start An Application'

    expect(current_path).to eq('/applications/new')

    fill_in 'first_name', with: 'Jenny'
    fill_in 'last_name', with: 'Branham'
    fill_in 'address', with: '3570 Cutter Ridge Rd'
    fill_in 'city', with: 'Conway'
    fill_in 'state', with: 'AR'
    fill_in 'zipcode', with: 72034

    click_on 'Create Application'


    expect(page).to have_content('Application for Jenny Branham')
    expect(page).to have_content('3570 Cutter Ridge Rd')
    expect(page).to have_content('Conway')
    expect(page).to have_content('AR')
    expect(page).to have_content('72034')
  end
  it 'can not create an application without a first_name or last_name' do
    visit '/pets'

    click_link 'Start An Application'

    expect(current_path).to eq('/applications/new')

    click_on 'Create Application'

    expect(page).to have_content("Application not created: First name can't be blank, Last name can't be blank, and Zipcode is not a number")

  end
end
