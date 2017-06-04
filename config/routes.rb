LasDeliciasFees::Application.routes.draw do # |map|
  
  match  'extracteds'=> 'extracteds#index', :via=> :get
  match "extracteds/:id" => 'extracteds#show' , :via => :get , :as => :extracted_show
  match "extracteds/:id/analyse" => 'extracteds#analyse' , :via => :get , :as => :extracted_analyse
  match 'extracteds/post_data' => 'extracteds#post_data'
  

  match 'feefiles/:id/display' => 'feefiles#display', :via=> :get, :as => :feefile_display
  resources :feefiles
  match 'comparisons' => 'debtors#comparisons'  , :via=>:get
  match 'ocmsummaries' => 'debtors#index'  , :via=>:get
  match 'debtors/preindex' => 'debtors#preindex', :via=> :get
    match 'debtors/download' => 'debtors#download', :via=> :get

  resources :debtors
  resources :user2s
  match 'user2s/post_data' => 'user2s#post_data'
    match 'feefile2s/:id/display' => 'feefile2s#display', :via=> :get, :as => :feefile2_display
    resources :feefile2s
 match 'feefiles/upload' => 'feefiles#upload'
 match 'feefiles/post_data' => 'feefiles#post_data'
post 'feefile/new' =>'feefile#new'
match 'feefiles/:id/extract' => 'feefiles#extract', :via=> :get, :as => :feefile_extract
match 'feefiles/:id/debtor' => 'feefiles#debtor', :via=> :get, :as => :feefile_debtor
match 'feefiles/:id/extracted' => 'feefiles#extracted', :as => :feefile_extracted
match 'feefiles/:id/download' => 'feefiles#download',  :as => "feefile_download" ,:via=>:get
  get "home/index"
get 'users/fred/' => 'users#fred#'
  #resources :users
  resources :users, only: [:new, :create]
  
  get    'login(.:format)'  => 'user_session#new',     :as => :login
 #match 'user_session/new', :via =>[:get],:as => :login
  post   'login(.:format)'  => 'user_session#create',  :as => :login
delete 'logout(.:format)' => 'user_session#destroy', :as => :logout
 get 'logout(.:format)' => 'user_session#destroy', :as => :logout , :via=>:get

  #root :to => 'user_session#new' # login page
  root :to => 'feefiles#index' 

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)feefiles/16

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
