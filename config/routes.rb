Rails.application.routes.draw do
  resources :characters, only: [ :index, :show ]
  resources :comics, only: [ :index, :show ]
  root 'pages#home'
end
