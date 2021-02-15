class ApplicationsController < ApplicationController
  def index
  end

  def show
    @application = Application.find(params[:id])
    if params[:pet_name]
      @pets = Pet.find_by_name(params[:pet_name])
    end
  end

  def new
  end

  def create
    application = Application.new(application_params)
    if application.save
      redirect_to "/applications/#{application.id}"
    else
      flash[:notice] = "Application not created: Required information missing."
      render "/applications/new"
    end
  end

  def update
    application = Application.find(params[:id])
    application.update(application_params)
    application.save
    redirect_to "/applications/#{application.id}"
  end

   private

   def application_params
     params.permit(:first_name, :last_name, :address, :city, :state, :zipcode, :description, :status)
   end
end
