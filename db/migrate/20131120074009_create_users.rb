class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :truename
      t.string :workunits
      t.string :userpost
      t.string :phone
      t.string :email
      t.integer :level, :default => 1
      t.integer :status, :default => 1

      t.timestamps
    end
  end
end
