Rails.application.routes.draw do
  root "messages#index"

  resources :messages

  namespace :api do
    namespace :v1 do
      resources :messages, only: [:index, :show, :create, :update, :destroy]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
