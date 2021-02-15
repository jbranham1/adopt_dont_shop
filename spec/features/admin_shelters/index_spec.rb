require 'rails_helper'

RSpec.describe 'Admin Shelters index page' do
  before :each do
    @shelter1 = Shelter.create!(name: "A Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
    @shelter2 = Shelter.create!(name: "Silly Shelter", address: "123 Silly Ave", city: "Denver", state: "CO", zip: 80012)
  end

  it "displays names of all shelters in reverse alphabetical" do
    visit '/admin/shelters'
    expect(page).to have_content(@shelter1.name)
    expect(page).to have_content(@shelter2.name)
    expect(@shelter2.name).to appear_before(@shelter1.name)
  end
end
