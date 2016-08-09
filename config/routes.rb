Feeder::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  get '/movies/search' => 'movies#search', as: :search_movies
  get '/search' => 'entries#search'

  resources :feeds, :constraints => { :id => /[^\/\.]+/ } do
    get 'carousel', :action => :carousel
    get ':id/page/:page', :action => :show, :on => :collection
    resources :entries

    resources :movies
  end

  resources :movies do
    # post 'search', on: :collection
  end

  namespace :admin do
    resources :members
    resources :feeds do
      resources :web_hooks
    end
    resources :sensors
    resources :queues, :only => [:index, :show]
    resources :jobs, :only => [:destroy], :constraints => { :id => /[^\/]+/ } do
      post :retry, :on => :member
    end
    resources :api_keys, except: [:show, :edit]
  end

  namespace :api do
    namespace :v1 do
      resource :import, only: [:create]
    end
  end

  #resources :atoms, :constraints => { :id => /[^\/\.]+/ }
  #resources :rss, :constraints => { :id => /[^\/\.]+/ }
  # put '/signin' => 'sessions#new', :as => :signin
  # put '/signout' => 'sessions#destroy', :as => :signout
  #
  # put '/auth/:provider/callback', :to => 'sessions#create'
  # put '/auth/failure', :to => 'sessions#failure'

  get 'rss/:slug' => 'rss#show', :as => :georss, defaults: {format: :xml}
  get 'rss/:slug/:id' => 'rss#show', :as => :georss_entry, defaults: {format: :xml}

  get ':slug.georss' => 'rss#show', defaults: {format: :xml}
  get ':slug/:id.georss' => 'rss#show', defaults: {format: :xml}
  get ':slug.xml' => 'rss#show', defaults: {format: :xml}
  get ':slug/:id.xml' => 'rss#show', defaults: {format: :xml}

  # match ':slug/:date' => 'feeds#show', :as => :slug_entries_by_date, :constraints => { :date => /\d+\/\d+/ }
  get ':slug/movies/:date/:duration' => 'movies#show', :as => :slug_movie, :constraints => { :date => /\d+\/\d+\/\d+/ }
  get ':slug/movies' => 'movies#index', :as => :slug_movies

  # match 'search/:q' => 'feeds#search', :as => :search
  get ':slug' => 'entries#index', :as => :slug
  get ':slug/carousel' => 'feeds#carousel'
  get ':slug/:id' => 'entries#show', :as => :slug_entry
  get ':slug/:id/embed' => 'entries#embed', :as => :embed_slug_entry
  get ':slug/:id/image' => 'entries#image', :as => :current_image
  get ':slug/:id/preview' => 'entries#preview', :as => :current_preview

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
  root :to => 'entries#search'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
