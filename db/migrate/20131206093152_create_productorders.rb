class CreateProductorders < ActiveRecord::Migration
  def change
    create_table :productorders do |t|
      t.integer :timeproduct_id
      t.integer :user_id
      t.integer :finalprice
      t.datetime :tradingtime
      t.integer :status, :default => 1
      t.string :ordernum

      t.timestamps
    end
  end
end
