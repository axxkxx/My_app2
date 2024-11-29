Rails.application.routes.draw do
  # Route สำหรับ Devise (การจัดการผู้ใช้)
  devise_for :users

  # Route สำหรับ Home Page
  authenticated :user do
    root to: "pages#home", as: :authenticated_root # หน้า home สำหรับผู้ใช้ที่ login
  end

  unauthenticated do
    root to: "devise/sessions#new", as: :unauthenticated_root # หน้า login สำหรับผู้ใช้ที่ไม่ได้ login
  end

  # เส้นทางไปยังหน้า Home (กรณีใช้ path `/home`)
  get 'home', to: 'pages#home', as: 'home'
  get 'pages/suggested', to: 'pages#suggested', as: 'suggested_users'
  get 'pages/:id', to: 'pages#show', as: 'user_profile'

  # Route สำหรับ Posts และ Nested Resources
  resources :posts do
    resources :comments, only: [:create, :destroy, :index, :new] # Comments ภายใต้ Posts
    resource :like, only: [:create, :destroy] # Like/Unlike ภายใต้ Posts
  end

  resources :users, only: [:show] # สำหรับโปรไฟล์ผู้ใช้

  # Route สำหรับตรวจสอบสถานะของแอป
  get "up" => "rails/health#show", as: :rails_health_check
end