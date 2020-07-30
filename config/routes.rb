Rails.application.routes.draw do
  root 'uploads#new'
  get 'uploads/new'
  get 'uploads/create'
  get 'uploads/index'
  resources :uploads
end
