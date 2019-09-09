Rails.application.routes.draw do
  resources :indices
  get 'rotatephoto', to: 'indices#rotate_photo'
  get 'sendphoto', to: 'indices#send_photo'
  get 'deletephoto', to: 'indices#delete_photo'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
