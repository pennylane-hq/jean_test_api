Rails.application.routes.draw do
  apipie

  root to: 'application#index'

  resources :customers, only: %i[show] do
    collection do
      get :search
    end
  end
  resources :products, only: %i[show] do
    collection do
      get :search
    end
  end
  resources :invoices, only: %i[index show create update destroy]
end
