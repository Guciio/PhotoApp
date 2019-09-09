Rails.application.routes.draw do
  resources :post_photos
  get 'rotatephoto', to: 'post_photos#rotate_photo'
  get 'deletephoto', to: 'post_photos#delete_photo'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
