Rails.application.routes.draw do
  get 'cloud_services/custom_requirements'
  get 'cloud_services/compare'
  root 'home#index'
  get 'requerment', to: 'home#requerment'
  get 'about', to: 'home#about'
  get 'documention', to: 'home#documention'
  get 'services', to: 'home#services'
  
  get 'user_list', to: 'admins#user_list', as: 'user_list'
  get 'contect_list', to: 'admins#contect_list', as: 'contect_list'
  # delete 'users/:id', to: 'admins#user_remove', as: 'user_remove'
  resources :admins do
    member do
      get 'message'
      get 'show_user'
    end
  end
  get 'azure/pricing', to: 'azure#pricing'
  get 'aws/pricing/:service_code', to: 'aws#pricing'
  get 'compare_cloud_services', to: 'cloud_comparison#compare'
  resources :contects
  devise_for :users

  resources :cloud_services do
    collection do
      post :compare
    end
  end
  get 'cloud_services/compare_remote_sql', to: 'cloud_services#compare_remote_sql', as: :compare_remote_sql
  post 'cloud_services/compare_remote_sql', to: 'cloud_services#compare_remote_sql'
  get 'cloud_services/predefined_services', to: 'cloud_services#predefined_services'
# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  # root "articles#index"
end
