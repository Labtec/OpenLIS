Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
  }, controllers: {
    sessions: 'sessions'
  }

  root 'patients#index'

  resources :users, only: [:edit, :update]
  get 'profile', to: 'users#edit'

  resources :doctors, only: :index

  resources :patients, shallow: true, except: :show do
    resources :accessions do
      resources :results, only: :index
    end
  end

  resources :accessions, only: :index do
    member do
      put 'report'
      get 'edit_results'
    end
  end

  get 'admin', controller: 'admin/users', action: :index

  namespace :admin do
    resources :users
    resources :doctors
    resources :insurance_providers do
      resources :claims, only: :index
      resources :prices
    end
    resources :accessions, only: :index do
      resource :claim, only: :new
    end
    resources :panels do
      resources :prices
    end
    resources :lab_test_values
    resources :reference_ranges
    resources :lab_tests do
      resources :prices
      collection do
        patch 'sort'
      end
    end
    resources :units
    resources :departments
    resources :claims, except: :new do
      collection do
        post 'submit_selected'
        post 'print_selected'
      end
      member do
        put 'submit'
      end
    end
    resources :prices
  end
end
