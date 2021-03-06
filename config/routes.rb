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

  namespace :dashboards do
    get '/ies/:id/full_compare',to:'ies#full_compare'
    get '/ies/:id/single',to:'ies#single'
    get '/ies/:id/cycle_time_detail/:node_id',to:'ies#cycle_time_detail'
  end

  resources :project_items do
    resources :records
    resources :pdca_items
    resources :nodes
    resource :diagram
    namespace :kpis do
      resource :setting
      get 'entries/export',to:'entries#export'
      get 'entries/search',to:'entries#search'
      resources :entries do
        collection do
          post :batch_destroy
        end
      end
    end
  end

  # get 'entries/search',to:'entries#search'

  resources :plans
  resources :tasks

  resources :project_users

  resources :projects do
    member do
      put 'switch'
    end

    collection do
      get '/compares/:id',to:'projects#compares'
    end
  end

  root :to => 'projects#index'

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
