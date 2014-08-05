Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  #devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions'}





devise_scope :user do
  authenticated :user do
    
    root :to => 'homepage#index', as: :authenticated_root
    end
 
  unauthenticated :user do
    root :to => 'devise/sessions#new', as: :unauthenticated_root
  end
end
  resources :attendances

  resources :in_groups

  resources :message_lists

  resources :messages
  

  get "/message_confirmation/:id" , :to => "messages#message_confirmation", :as => 'message_confirmation'
  get "/user_message_confirmations" => "messages#user_message_confirmations"
  post "/validate_message/:id" , :to => "messages#validate_message", :as => 'validate_message'
  get "/received_messages/", :to => "messages#received_messages", :as => 'received_messages'

  get "/update_attendance_form/:id", :to => "attendances#update_attendance_form", :as => 'update_attendance_form'
  post "/updateattendance/:id" , :to => "attendances#updateattendance", :as => 'update_attendance'

  get "/show_members/:id", :to => "in_groups#show_members", :as => 'show_members'

  resources :groups

  


  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
