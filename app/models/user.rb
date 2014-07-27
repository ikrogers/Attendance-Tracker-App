class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :session_limitable
         
  has_many :in_group, :dependent => :delete_all
  

  has_many :messages 
  validates :fname, :presence => true
  validates :lname, :presence => true
  validates :email, :presence => true,
                    :format => { :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, :message => "is in invalid format" } 
  validates :phone, :format => { :with => /\A(\+1)?[0-9]{10}\z/, :message => "not a valid 10-digit telephone number" } 
  validates :carrier, :presence => true
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {:within => 6..40},
                       :on => :create
  validates :password, :confirmation => true,
                       :length => {:within => 6..40},
                       :allow_blank => true,
                       :on => :update


  
  
     
    
    
  def send_confirm_message(message)
  self.confirmtoken_sent_at = Time.zone.now
  save!
  UserMailer.message_confirm(self, message).deliver
end  

def send_confirm_message_text(message, number)
  self.confirmtoken_sent_at = Time.zone.now
  save!
  UserMailer.message_confirm_text(self, message, number).deliver
end  
end
