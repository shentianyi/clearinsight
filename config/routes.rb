Rails.application.routes.draw do
  resources :tasks

  resources :project_users

  resources :projects do
    collection do
      match :invite_people, to: :invite_people, via: [:get, :post]
    end
  end

  root :to => 'welcome#index'

  post 'users', to: 'users#create'

  resources :tenants

  devise_for :users, controllers: {
                       sessions: 'users/sessions'#, registrations: 'users/registrations'
                   }

  resources :users do
    collection do
      get :search
    end
  end

  namespace :admin do
    resources :tenants
    get '/' => 'tenants#index'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
