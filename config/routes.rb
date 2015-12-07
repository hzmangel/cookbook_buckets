Rails.application.routes.draw do
  root 'cookbooks#index'
  resources :cookbooks
end
