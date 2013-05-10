Battle45::Application.routes.draw do

  resources :games

  root :to => 'games#index'
end
