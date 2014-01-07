if File.exists?("#{RAILS_ROOT}/client/config/routes.rb")
  require 'client/config/routes.rb'
elsif File.exists?("#{RAILS_ROOT}/client/config/client_routes.rb")
  require 'client/config/client_routes.rb'
end
ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  map.home '', :controller => 'home'
  map.resource :session
  map.resources :members do |member|
    member.resources :links
    member.resources :videos
    member.resource :media_library, :controller => 'media_library'
  end
  map.resources :attachables, :as => :members, :class => "Member" do |member|
    member.resources :photo_albums
  end
  map.resources :sections, :has_many => [:sections, :pages]
  map.connect "sections/archive/:id", :controller => "sections", :action => "archive"
  map.connect "sections/archive/:id/:year/:month", :controller => "sections", :action => "archive"
  map.connect "sections/rss/:id", :controller => "sections", :action => "rss"
  map.resources :pages
  map.resources :mails, :member => {:read => :get, :send_email => :get}
  map.resources :mailings, :member => {:send_emails => :get}
  map.resources :links
  map.resources :videos
  map.resources :photos
  map.resources :photo_albums do |photo_album|
    photo_album.resources :photos, :collection => {:ajax => :get}
  end
  map.resources :searches, :controller => :search, :as => :search, :collection => {:jquery_autocomplete => :get}
  map.resources :document_folders do |document_folder|
    document_folder.resources :documents
  end
  map.resources :documents
  map.resources :statuses
  map.resources :news_feed_items  
  map.resources :reports
  
  map.resources :staff_members, :except => [:show]

  map.connect 'share/create/:id', :controller => 'share', :action => 'create'
  map.connect 'share/:model_name/:id', :controller => 'share', :action => 'new'
  
  map.connect 'logged-out', :controller => 'home'
  map.admin '/admin', :controller => 'admin'

  map.login '/login', :controller => 'sessions', :action => 'new'

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  #map.root :home
  map.root :controller => 'home'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
