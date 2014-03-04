class CreateAucrecords < ActiveRecord::Migration
  def change
    create_table :aucrecords do |t|
      t.integer :timeproduct_id
      t.integer :bidnum
      t.integer :user_id
      t.datetime :bidtime
      t.integer :status, :default => 1

      t.timestamps
    end
  end
end
