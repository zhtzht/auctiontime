class Uidtid < ActiveRecord::Base
  
  self.table_name = "uidtids"
  belongs_to :user, foreign_key: 'user_id'
  belongs_to :timeproduct, foreign_key: 'timeproduct_id'
end
