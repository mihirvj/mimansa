class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :first_name
      t.string :last_name
      t.boolean :is_admin
      t.datetime :last_logged
      t.boolean :is_super_admin

      t.timestamps
    end
  end
end
