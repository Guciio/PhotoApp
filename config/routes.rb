Rails.application.routes.draw do
  resources :post_photos
  get 'rotatephoto', to: 'post_photos#rotate_photo'
  get 'deletephoto', to: 'post_photos#delete_photo'
  get 'bluephoto', to: 'post_photos#blue_photo'
  get 'flipphoto', to: 'post_photos#flip_photo'
  get 'downloadphoto', to: 'post_photos#download_photo'
  match 'download', to: 'post_photos#download_photo', as: 'download', via: :get
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
