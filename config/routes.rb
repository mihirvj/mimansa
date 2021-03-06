Mimansa::Application.routes.draw do
  resources :categories


  root :to => 'posts#index'

  resources :posts
  resources :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  get 'vote_up/:id' => 'Posts#vote_up', as: 'vote_up'
  match 'posts/:id/comment', :to => 'posts#comment', :as => 'comment'
  match 'posts/:id/comment_vote_up', :to => "posts#comment_vote_up", as: 'comment_vote_up'
  match 'posts/:id/comment_destroy', :to => "posts#comment_destroy", as: 'comment_destroy'
  get 'posts/:id/edit', :to => "posts#edit", as: 'edit'

  get 'posts/:id/comment_edit', :to => "posts#comment_edit", as: 'comment_edit'
  post 'posts/:id/edit_comment', :to => "posts#edit_comment", as: 'edit_comment'

  resources :sessions, only: [:new, :create, :destroy]

  match '/signup', to: 'users#new', via: 'get'
  match '/login', to: 'sessions#new', via: 'get'
  match '/logout', to: 'sessions#destroy', via: 'get'

  match '/users', :to => 'users#index', via: 'get' #mihir
  match '/users/:id/set_admin', :to => 'users#set_admin', as: 'set_admin' #mihir
  match '/users/:id/unset_admin', :to => 'users#unset_admin', as: 'unset_admin' #mihir
  match '/report' => 'users#report', via: 'get' #mihir

  match '*akjdbaskd' => 'sessions#notfound'
end
