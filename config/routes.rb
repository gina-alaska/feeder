Feeder::Application.routes.draw do
  resources :feeds, :constraints => { :id => /[^\/\.]+/ } do
    get 'carousel', :action => :carousel
    get ':id/page/:page', :action => :show, :on => :collection
    resources :entries
    
    resources :movies
  end

  #resources :atoms, :constraints => { :id => /[^\/\.]+/ }
  #resources :rss, :constraints => { :id => /[^\/\.]+/ }

  match 'rss/:slug' => 'rss#show', :as => :georss, :format => :xml
  match 'rss/:slug/:id' => 'rss#show', :as => :georss_entry, :format => :xml

  match ':slug.georss' => 'rss#show', :format => :xml
  match ':slug/:id.georss' => 'rss#show', :format => :xml
  match ':slug.xml' => 'rss#show', :format => :xml
  match ':slug/:id.xml' => 'rss#show', :format => :xml
  
  # match ':slug/:date' => 'feeds#show', :as => :slug_entries_by_date, :constraints => { :date => /\d+\/\d+/ } 
  match ':slug/movies/:date' => 'movies#show', :as => :slug_movie, :constraints => { :date => /\d+\/\d+\/\d+/ } 
  
  match ':slug' => 'feeds#show', :as => :slug
  match ':slug/carousel' => 'feeds#carousel'
  match ':slug/:id' => 'feeds#show', :as => :slug_entry
  match ':slug/:id/image' => 'feeds#image', :as => :current_image
  
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
  root :to => 'feeds#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
