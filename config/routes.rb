Rails.application.routes.draw do
  devise_for :users, path_names: {
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
    resources :lab_tests, collection: { sort: :patch } do
      resources :prices
    end
    resources :units
    resources :departments
    resources :claims, only: :index, member: { submit: :put }
    resources :claims, collection: { submit_selected: :post }
    resources :claims, collection: { print_selected: :post }
    resources :prices
  end
end
