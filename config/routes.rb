# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: '',
                     path_names: { sign_in: 'login',
                                   sign_out: 'logout' },
                     controllers: { sessions: 'auth/sessions' },
                     format: false

  root 'patients#index'

  resources :users, only: %i[edit update]
  get 'profile', to: 'users#edit'

  resources :patients, shallow: true do
    resources :accessions, only: [:new, :create]
    member do
      get 'history'
    end
  end

  resources :accessions, except: [:new, :create, :show]

  resources :diagnostic_reports, only: [:index, :show, :edit, :update] do
    member do
      patch 'certify'
      put 'email'
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
    resources :accessions, only: [] do
      resource :claim, only: :new
    end
    resources :panels do
      resources :prices
    end
    resources :lab_test_values
    resources :qualified_intervals
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

  match '*unmatched_route',
        via: :all,
        to: 'application#raise_not_found',
        format: false
end
