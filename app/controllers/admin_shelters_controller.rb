class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.by_reverse_alphabetical
  end

  def show
    @shelter = Shelter.shelter_with_name_and_address(params[:id]).first
  end
end
