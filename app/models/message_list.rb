class MessageList < ActiveRecord::Base
   has_many :messages 
   has_many :users
   
   def gentoken
    gen_token(:messageconfirmtoken)
   end
  
  
  def gen_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
     end while MessageList.exists?(column => self[column])
    end  
    
    def send_confirm_message(user, message, email)
       self.confirmtoken_sent_at = Time.zone.now
       save!
       UserMailer.message_confirm(user, message, email).deliver
    end  

    def send_confirm_message_text(user, message, number)
     self.confirmtoken_sent_at = Time.zone.now
     save!
     UserMailer.message_confirm_text(user, message, number).deliver
    end  
end
