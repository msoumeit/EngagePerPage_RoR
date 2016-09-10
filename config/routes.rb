WWIT::Application.routes.draw do

  root "wwit#index"
  get "blog" => "wwit#works"
  devise_for :businesses, skip: :registrations, :controllers => {:sessions => "businesses/sessions",
                                                                 :passwords => 'businesses/passwords',
                                                                 :invitations => 'businesses/invitations'}
                                                                 
  devise_scope :businesses do
      resource :registration,
      #only: [:new, :create, :edit, :update],
      only: [:edit, :update],
      path: 'businesses',
      path_names: { new: 'sign_up' },
      controller: 'businesses/registrations',
      as: :business_registration do
        get :cancel
      end
    end
    
  devise_for :users, skip: :registrations, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" ,
                                                             :sessions => "users/sessions",
                                                             :passwords => 'users/passwords'}

  devise_scope :user do
    resource :registration,
    only: [:new, :create, :edit, :update],
    path: 'users',
    path_names: { new: 'sign_up' },
    controller: 'users/registrations',
    as: :user_registration do
      get :cancel
    end
  end

  get "dashboard" => "home#index"
  get "widgets" => "widgets#index"
  get "invite" => "wwit#invite_req"
  post "invited" => "wwit#invite_sent"
  post "invited_main" => "wwit#invite_main"
  get "feedback" => "wwit#feedback_req"
  post "feedback_rec" => "wwit#feedback"
  get "demo" => "wwit#demo_business"

  get 'playersingame/:id' => 'players#players_for_game'

  #get 'stages/:id/show' => 'stages#show_game'
  #post 'stages/check_answer/:id' => 'stages#check_answer'

  match 'stages/get_level_task' => 'stages#get_level_task', :via => :get
  match 'stages/:id/assist' => 'stages#assist' ,:via => :get
  match 'stages/:id/wallet' => 'stages#wallet' ,:via => :get
  

  match 'games/:id/WOFF' => 'games#wall_of_fame' ,:via => :get
  match 'games/:id/activate' => 'games#set_reviewed' ,:via => :get
  match 'games/:id/demo' => 'games#demo' ,:via => :get
  match 'games/:id/generate_leads' => 'games#generate_leads' ,:via => :get

  resources :stages do
    member do
      post :show_game
      get :show_game
      post :check_answer
      post :facebook_post
      get :facebook_post
      post :twitter_post
      get :twitter_post
      get :get_level_task
      get :fb_logout
      get :tw_logout
      post :update_user
    end
  end

  get "start_game" => "stages#start_game"
  post "start_game" => "stages#start_game"

  resources :puzzles

  resources :task

  resources :pictures

  resources :games

  get "new_level" => "levels#new"
  get "leaders/game/:id" => "players#leaderboard"

  #resources :levels

  resources :games  do
    resources :levels
    resources :prizes
  end

  resources :incentives

  resources :prizes  , :controller => "incentives", :type => "Prize"
  resources :rewards , :controller => "incentives", :type => "Reward"

  resources :levels  do
    resources :rewards
  end

  resources :players

  get "stats" => "statistics#index"
  get "game_power" => "statistics#game_power"
  get "magnetic_power" => "statistics#magnetic_power"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

  match '*unmatched_route', :to => 'application#raise_not_found!', via: [:get, :post]
end
