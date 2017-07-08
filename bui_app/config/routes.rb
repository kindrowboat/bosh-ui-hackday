Rails.application.routes.draw do
  resources :deployments
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :deployments
end
