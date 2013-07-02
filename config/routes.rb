RadioCollarBackend::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :sessions
      devise_scope :user do
        #Can we do resources :registrations instead to make it easier on backbone?
        post "register", to: "registrations#create"
        post "reset_password", to: "registrations#reset_password"
      end
      resources :places
    end
  end

  root to: 'pages#index'

  match '/:unique_key' => 'mongoid_shortener/shortened_urls#translate', :via => :get, :constraints => { :unique_key => "~.+" }
end
