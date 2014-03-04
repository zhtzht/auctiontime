class User < ActiveRecord::Base
  self.table_name = "users"
  before_create :create_remember_token
  has_many :uidtids, dependent: :destroy
  has_many :timeproducts, through: :uidtids
   
    
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true, length: { maximum: 20 } 
  has_secure_password
  validates :password, length: { minimum: 6 }
  validates_uniqueness_of :name
  validates_presence_of :truename, :phone, :workunits
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  private
  
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
