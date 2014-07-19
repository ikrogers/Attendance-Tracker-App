class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :in_group

  
  has_many :messages 
  validates :fname, :presence => true
  validates :lname, :presence => true
  validates :email, :presence => true
  validates :phone, :format => { :with => /\A(\+1)?[0-9]{10}\z/, :message => "Not a valid 10-digit telephone number" } 
  validates :carrier, :presence => true



  
  
     
    
    
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
