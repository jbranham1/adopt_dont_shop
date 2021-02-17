class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.by_reverse_alphabetical
    @pending_shelters = Shelter.shelters_with_pending_applications
  end

  def show
    @shelter = Shelter.shelter_with_name_and_address(params[:id]).first
  end
end
