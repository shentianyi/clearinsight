Rails.application.routes.draw do
  resources :kpis
  resources :nodes
  resources :node_sets
  resources :diagrams do
    resources :nodes
  end
  resources :project_items
  resources :plans
  resources :tasks

  resources :project_users

  resources :projects

  root :to => 'welcome#index'

  post 'users', to: 'users#create'

  resources :tenants

  devise_for :users, controllers: {
                       sessions: 'users/sessions' #, registrations: 'users/registrations'
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

  #api
  get 'api' => 'home#api', as: 'api'
  namespace :api, :defaults => {:format => 'json'} do
    resources :user
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
