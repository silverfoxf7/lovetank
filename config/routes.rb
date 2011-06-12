SampleApp::Application.routes.draw do
 
  resources :users do
    member do
      get :following, :followers, :billable_jobs, :partner_new, :partner_create
    end
    
    # gets pages for users/1/followers, . . ., users/199/followers . . .
    # named route = following_user_path(1)
    # named route = billable_jobs_user_path(1)
  end

  resources :partners,   :only => [:new, :create, :destroy]
  resources :loveactions, :only => [:create, :destroy]
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
  
  match '/facebook/confirm', :to => 'facebook#confirm'
  # takes the website route /ZOT and matches to contrller_zot # ZOT-rsrc

  
end
