Rails.application.routes.draw do
  root 'home#index'
  resources :cookbooks, except: [:new, :edit], defaults: { format: 'json' } do
    post 'search', on: :collection
  end

  resources :materials, only: [:index], defaults: { format: 'json' }
end
