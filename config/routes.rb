Fluxday::Application.routes.draw do

  resources :oauth_applications

  use_doorkeeper
  resources :okrs

  #resources :objectives do
  #  resources :key_results
  #end

  get "reports/index"
  get "reports/activities"
  get "reports/employees_daily"
  get "reports/employee_day"
  get "reports/employees_time_range"
  get "reports/employee_range"
  get "reports/tasks"
  get "reports/task"
  get "reports/okrs"
  get "reports/get_selection_list"
  get "reports/employee_tasks"
  get "reports/worklogs"
  get "reports/day_log"
  get "reports/assignments"

  resources :work_logs do
    member do
      post 'delete_request'
      post 'ignore_request'
    end
  end

  get "calendar/index"
  get "calendar/monthly"
  get "calendar/day"
  get "calendar/week"
  resources :comments do
    member do
      get 'reply'
      post 'post_reply'
    end
  end

  resources :tasks do
    resources :comments
    member do
      post 'completion'
    end
    collection do
      get 'completed_index'
    end
  end

  resources :teams do
    get 'add_members'
    post 'add_members'
    collection do
      get 'get_member_list'
    end
  end

  get "home/index"
  get "home/dashboard"
  get "home/search"
  post "home/search"
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  resources :projects do
    resources :teams
  end

  resources :users do
    resources :okrs do
      member do
        post 'approve'
      end
    end
    collection do
      get 'change_password'
      post 'change_password'
    end
  end

  #namespace :api do
  #  namespace :v1 do
  #    get '/me' => "credentials#me"
  #  end
  #end
  namespace :api do
    namespace :v1 do
      get '/me' => "credentials#me"
    end
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

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
