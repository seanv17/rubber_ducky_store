Rails.application.routes.draw do

  devise_for :users

  # Set routes for charges and invoices controllers
  resources :charges
  resources :invoices

  root to: 'home#home'

end
