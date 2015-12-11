Rails.application.routes.draw do
  root 'home#index'
  resources :cookbooks, except: [:new, :edit], defaults: { format: 'json' }
end
