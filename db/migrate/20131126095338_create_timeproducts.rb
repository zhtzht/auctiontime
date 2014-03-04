class CreateTimeproducts < ActiveRecord::Migration
  def change
    create_table :timeproducts do |t|
      t.date :name
      t.integer :lowprice
      t.integer :merprice
      t.datetime :starttime
      t.datetime :continuedtime
      t.integer :status, :default => 1

      t.timestamps
    end
  end
end
