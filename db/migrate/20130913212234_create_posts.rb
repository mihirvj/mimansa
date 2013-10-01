class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :subject
      t.text :description
      t.integer :created_by
      t.references :categories

      t.timestamps
    end
  end
end
