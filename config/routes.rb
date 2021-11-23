Rails.application.routes.draw do
  get 'users/index'
  get 'users/new'
  get 'users/edit'
  get 'users/show'
 root 'users#show'
end
