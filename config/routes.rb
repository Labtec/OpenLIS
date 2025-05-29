# frozen_string_literal: true

Rails.application.routes.draw do
  get ".well-known/change-password", to: "well_known#change_password"
  get ".well-known/jwks", to: "well_known#jwks", as: :well_known_jwks, format: :json

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_scope :user do
    namespace :auth do
      get "sessions/security_key_options", to: "sessions#webauthn_options"
    end
  end

  devise_for :users, path: "",
                     path_names: { sign_in: "login",
                                   sign_out: "logout" },
                     controllers: { sessions: "auth/sessions" },
                     format: false

  root "patients#index"

  resources :users, only: %i[edit update]
  get "profile", to: "users#edit"

  namespace :settings do
    resources :webauthn_credentials, only: %i[new create destroy], path: "security_keys" do
      collection do
        get :options
      end
    end
  end

  resources :patients, shallow: true do
    resources :accessions, only: [ :new, :create ]
    member do
      get "history"
    end
  end

  resources :accessions, except: [ :new, :create, :show ]
  resources :labels, only: [ :show ], format: :pdf

  resources :diagnostic_reports, only: [ :index, :show, :edit, :update ] do
    member do
      patch "certify"
      patch "force_certify"
      put "email"
    end
  end

  resources :quote_details, only: [ :edit, :update ]

  resources :quotes do
    resources :versions, controller: "quote_versions", only: :new
    member do
      patch "approve"
      post "order"
      put "email"
    end
  end

  get "admin", controller: "admin/users", action: :index

  namespace :admin do
    resources :users
    resources :doctors, except: [ :show ]
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
    resources :lab_test_values, except: [ :show ]
    resources :qualified_intervals, except: [ :show ]
    resources :lab_tests do
      resources :prices
      member do
        patch "sort"
      end
    end
    resources :units, except: [ :show ]
    resources :departments
    resources :claims, except: :new do
      collection do
        post "submit_selected"
        post "process_selected"
      end
      member do
        put "submit"
      end
    end
    resources :prices
  end

  namespace :fhir, format: :json do
    get "Patient/:id", to: "patients#show", as: "patient"
    get "DiagnosticReport/:id", to: "diagnostic_reports#show", as: "diagnostic_report"
    get "Practitioner/:id", to: "doctors#show", as: "doctor"
  end

  namespace :lab_connect, format: :json do
    resources :diagnostic_reports, only: [ :update ]
  end

  match "*unmatched_route",
        via: :all,
        to: "application#raise_not_found",
        format: false
end
