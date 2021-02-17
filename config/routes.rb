Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "welcome#index"

  resources :shelters, :pets, :applications, :application_pets
  resources :admin_applications, path: '/admin/applications'
  resources :admin_applications, path: '/admin/applications'
  resources :admin_shelters, path: '/admin/shelters'

  get "/shelters/:shelter_id/pets", to: "shelter_pets#index"
  get "/shelters/:shelter_id/pets/new", to: "shelter_pets#new"
  post "/shelters/:shelter_id/pets", to: "shelter_pets#create"
  get "/shelters/:id/pets/:id", to: "pets#show"
end
