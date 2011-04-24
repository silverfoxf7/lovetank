SampleApp::Application.routes.draw do
 
  resources :users do
    member do
      get :following, :followers, :billable_jobs
    end
    # gets pages for users/1/followers, . . ., users/199/followers . . .
    # named route = following_user_path(1)
    # named route = billable_jobs_user_path(1)
  end
 
  resources :sessions,   :only => [:new, :create, :destroy]
  # the additional argument limits which actions the resource can take
  resources :microposts, :only => [:create, :destroy]
  # resources :jobposts, :only => [:create, :destroy]

#################################
          resources :jobposts do
            member do
              get :winners
            end
              resources :bids #, :only => [:create, :destroy]
          end

          resources :bids do #, :only => [:create, :destroy] do
              resources :microposts, :only => [:create, :destroy]
          end
#################################

  resources :relationships, :only => [:create, :destroy]
  resources :winationships, :only => [:create, :destroy]
  
  root :to => "pages#home"  

  match '/allbids',  :to => 'bids#index'

  match '/contact',   :to => 'pages#contact'
  match '/about',     :to => 'pages#about'
  match '/help',      :to => 'pages#help'
 #match '/projects',  :to => 'pages#projects'
  match '/projects',  :to => 'jobposts#index'
 #match '/post_project',  :to => 'pages#post_project'
  match '/post_project',  :to => 'jobposts#new'
  match '/preview_project',  :to => 'jobposts#preview'
  match '/signup',    :to => 'users#new'
  match '/signin',    :to => 'sessions#new'
  match '/signout',   :to => 'sessions#destroy'
  # takes the website route /ZOT and matches to contrller_zot # ZOT-rsrc

  
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
  #     # (app/controllers/rooadmin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
