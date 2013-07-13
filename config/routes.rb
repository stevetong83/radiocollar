RadioCollarBackend::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post "register", to: "registrations#create"
        post "reset_password", to: "registrations#reset_password"
        post 'sessions', to: 'sessions#create'
        delete 'sessions', to: 'sessions#destroy'
      end
      resources :places
    end
  end

  root to: 'pages#index'

  match '/:unique_key' => 'mongoid_shortener/shortened_urls#translate', :via => :get, :constraints => { :unique_key => "~.+" }
end
