class CreateIndices < ActiveRecord::Migration[6.0]
  def change
    create_table :indices do |t|

      t.timestamps
    end
  end
end
