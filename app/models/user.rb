class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :session_limitable
         
  has_many :in_group
  

  

  
  
     
    
    
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
