Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
  }

  root 'patients#index'

  resources :users
  get 'profile' => 'users#edit'
  resources :doctors, only: :index

  resources :patients, shallow: true do
    resources :accessions do
      resources :results
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
      resources :claims
      resources :prices
    end
    resources :accessions do
      resource :claim
    end
    resources :panels do
      resources :prices
    end
    resources :lab_test_values
    resources :lab_test_value_options
    resources :reference_ranges
    resources :lab_tests do
      resources :prices
      collection do
        patch 'sort'
      end
    end
    resources :units
    resources :departments
    resources :claims do
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
