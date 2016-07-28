Rails.application.routes.draw do

  resources :task_users
  resources :pdca_items
  use_doorkeeper


  # resources :kpi

  resources :nodes
  resources :node_sets
  resources :diagrams do
    resources :nodes
  end

  namespace :kpis do
    resources :settings do
      resources :targets
      resources :setting_items
    end
     resources :targets
  end

  resources :dashboards do
    member do
      get :ie
    end
  end

  resources :project_items do
    collection do
      get '/:id/nodes', to: 'project_items#nodes'
    end
  end

  resources :plans
  resources :tasks

  resources :project_users

  resources :projects

  root :to => 'welcome#index'

  post 'users', to: 'users#create'
  get 'users/check_email', to: 'users#check_email'

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
    namespace :v1 do

      resources :projects do
        collection do
          get :work_unit_nodes
        end
      end

      resources :users do
        collection do
          post :login
          post :logout
        end
      end

      namespace :kpis do
        resources :entries
      end
      resources :nodes do
        collection do
          put :bind_devise
        end
      end

    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
