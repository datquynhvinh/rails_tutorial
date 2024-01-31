Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions'
  }

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/news', to: 'static_pages#news'

  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :courses, only: [:index] do
    resources :lessons, only: [:index] do
      resources :sections, only: [:index]
    end
  end
  resources :users do
    member do
      get :following, :followers
    end
    resources :user_section_statuses, only: [:update], param: :section_id
  end

  # Admin
  namespace :admin do
    root 'dashboard#index'
    resources :dashboard, only: [:index]
    resources :courses
    resources :lessons do
      resources :sections
    end
    resources :users do
      resources :user_courses, only: [:index, :new, :create, :destroy]
      member do
        get 'lessons/:course_id', to: 'user_courses#lessons', as: :lessons
        get 'lessons/:course_id/sections/:lesson_id', to: 'user_courses#sections', as: :sections
      end
    end
  end
end
