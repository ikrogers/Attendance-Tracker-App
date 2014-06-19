class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
     has_many :messages 
   def gen_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
     end while User.exists?(column => self[column])
    end    
    
    
    def send_confirm_message
  gen_token(:messageconfirmtoken)
  self.confirmtoken_sent_at = Time.zone.now
  save!
  UserMailer.message_confirm(self).deliver
end  
end
