Rails.application.routes.draw do
  resources :project_items
  resources :plans
  resources :tasks

  resources :project_users

  resources :projects do
    collection do
      match :create_basic, to: :create_basic, via: [:get, :post]
      match :invite_people, to: :invite_people, via: [:get, :post]
      match :add_plan, to: :add_plan, via: [:get, :post]
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
