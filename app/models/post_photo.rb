class PostPhoto < ApplicationRecord
  has_one_attached :image
end
