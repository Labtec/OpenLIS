# frozen_string_literal: true

Rails.application.routes.draw do
  get '.well-known/change-password', to: 'well_known#change_password'
  get '.well-known/jwks', to: 'well_known#jwks', as: :well_known_jwks, format: :json

  # get 'up' => 'rails/health#show', as: :rails_health_check

  devise_scope :user do
    namespace :auth do
      get 'sessions/security_key_options', to: 'sessions#webauthn_options'
    end
  end

  devise_for :users, path: '',
                     path_names: { sign_in: 'login',
                                   sign_out: 'logout' },
                     controllers: { sessions: 'auth/sessions' },
                     format: false

  root 'patients#index'

  resources :users, only: %i[edit update]
  get 'profile', to: 'users#edit'

  namespace :settings do
    resources :webauthn_credentials, only: %i[new create destroy], path: 'security_keys' do
      collection do
        get :options
      end
    end
  end

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
      patch 'force_certify'
      put 'email'
    end
  end

  resources :quote_details, only: [:edit, :update]

  resources :quotes do
    resources :versions, controller: 'quote_versions', only: :new
    member do
      patch 'approve'
      post 'order'
      put 'email'
    end
  end

  get 'admin', controller: 'admin/users', action: :index

  namespace :admin do
    resources :users
    resources :doctors, except: [:show]
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
    resources :lab_test_values, except: [:show]
    resources :qualified_intervals, except: [:show]
    resources :lab_tests do
      resources :prices
      member do
        patch 'sort'
      end
    end
    resources :units, except: [:show]
    resources :departments
    resources :claims, except: :new do
      collection do
        post 'submit_selected'
        post 'process_selected'
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
