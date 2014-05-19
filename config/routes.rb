Rails.application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  resources :schedules do
    collection do
      post 'upload_schedules'
    end
  end

  root 'welcome#index'
end
