class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def update
    application = Application.find(params[:id])
    application_pet = ApplicationPet.find(params[:ap_id])
    application_pet.update(pets_params)
    if application.application_pets.all?(&:approved?)
      application.update(status: :approved)
    else
      application.update(status: :rejected)
    end
    application.save
    application_pet.save
    redirect_to "/admin/applications/#{params[:id]}"
  end

  private

  def pets_params
    params.permit(:status)
  end
end
