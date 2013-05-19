Battle45::Application.routes.draw do

  resources :games do
    resources :nukes, only: [:create]
  end

  root :to => 'games#index'
end
