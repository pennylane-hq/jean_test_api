Rails.application.routes.draw do
  root to: 'application#index'

  mount OpenApi::Rswag::Ui::Engine => '/api-docs'

  get '/schema' => 'application#schema'

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
