class Timeproduct < ActiveRecord::Base
  
  self.table_name = "timeproducts"
  has_many :uidtids, dependent: :destroy
  has_many :users, through: :uidtids
  
  
  validates_uniqueness_of :name, message: "该商品已经存在"
  validates_presence_of :lowprice, :merprice
end
