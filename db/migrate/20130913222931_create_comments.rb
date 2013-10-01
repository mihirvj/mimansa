class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :description
      t.integer :created_by
      t.references :posts

      t.timestamps
    end
  end
end
