class CreatePostPhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :post_photos do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
