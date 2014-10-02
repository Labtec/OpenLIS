Rails.application.routes.draw do
  root 'patients#index'

  get 'login' => 'user_sessions#new'
  get 'logout' => 'user_sessions#destroy'
  resources :user_sessions, as: 'try_again'

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

  # map :admin, controller: 'admin/users', action: :index

  namespace :admin do
    resources :users
    resources :doctors
    resources :insurance_providers, has_many: [:claims, :prices]
    resources :accessions, has_one: :claim
    resources :panels, has_many: :prices
    resources :lab_test_values
    resources :lab_test_value_options
    resources :reference_ranges
    resources :lab_tests, collection: { sort: :patch }, has_many: :prices
    resources :units
    resources :departments
    resources :claims, only: :index, member: { submit: :put }
    resources :claims, collection: { submit_selected: :post }
    resources :claims, collection: { print_selected: :post }
    resources :prices
  end

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
