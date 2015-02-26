Ca::Application.routes.draw do

  root "static_pages#home"
  get "/chat", to: "static_pages#chat"
  get "/about", to: "static_pages#about"
  get "/terms", to: "static_pages#terms"
  get "/privacy", to: "static_pages#privacy"

  # Doesn't create any routes, simply enables Devise helpers for User objects
  devise_for :user, skip: [:sessions, :registrations, :passwords, :confirmations]

  devise_scope :user do
    post '/login', to: 'sessions#create', as: :user_session
    delete '/logout', to: 'sessions#destroy', as: :destroy_user_session

    post '/signup', to: 'registrations#create', as: :user_registration

    get '/forgot_password', to: 'passwords#new', as: :new_user_password
    post '/forgot_password', to: 'passwords#create', as: :user_password
    get '/reset_password', to: 'passwords#edit', as: :edit_user_password
    patch '/reset_password', to: 'passwords#update'
    put '/reset_password', to: 'passwords#update'

    post '/confirm_account', to: 'confirmations#create', as: :user_confirmation
    get '/confirm_account', to: 'confirmations#show'
  end

end
