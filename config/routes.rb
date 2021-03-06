Prairie0::Application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'people#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :checkbox_boolean_fields, only: [:edit, :update]
  resources :choices, except: [:index, :show]
  resources :education_levels, except: :show
  resources :field_sets
  resources :field_values, only: :index
  resources :location_searches, only: [:index, :new, :create]
  resources :locations
  resources :numeric_fields, only: [:edit, :update]
  resources :people
  resources :person_searches, only: [:index, :new, :create]
  resources :radio_button_fields, only: [:edit, :update]
  resources :select_fields, only: [:edit, :update]
  resources :setup_choice_fields, except: :index
  resources :setup_numeric_fields, except: [:index, :show]
  resources :setup_string_fields, except: [:index, :show]
  resources :string_fields, only: [:edit, :update]

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
