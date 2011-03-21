SageTestProject::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => 'sessions', :registrations => 'registrations' }
  
  resource :profile
  resources :invitations do
    member do
      get :accept, :reject
    end
  end

  root :to => "home#show"
end
