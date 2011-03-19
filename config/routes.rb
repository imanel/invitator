SageTestProject::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => 'sessions', :registrations => 'registrations' }
  
  resource :profile

  root :to => "home#show"
end
