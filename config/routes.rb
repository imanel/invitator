SageTestProject::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => 'sessions', :registrations => 'registrations' }
  
  resource :profile
  resources :invitations

  root :to => "home#show"
end
