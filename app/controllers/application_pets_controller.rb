class ApplicationPetsController < ApplicationController
  def create
    ap = ApplicationPet.create(application_pet_params)
    redirect_to "/applications/#{params[:application_id]}"
  end

  private

  def application_pet_params
   params.permit(:application_id, :pet_id)
  end
end
