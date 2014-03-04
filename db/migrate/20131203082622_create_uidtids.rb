class CreateUidtids < ActiveRecord::Migration
  def change
    create_table :uidtids do |t|
      t.integer :user_id
      t.integer :timeproduct_id
      t.integer :status, :default => 1

      t.timestamps
    end
  end
end
