class UserMailer < ActionMailer::Base
default from: 'RECALL@do-not-reply.com'
 @msg = ""
  def recall_email(email, message)
    @email = email
    @msg = message.messages
    @url  = 'http://example.com/login'
    mail(to: @email, 
    subject: "RECALL"
   )
  end
  def recall_email_text(phone, message)
    @phone = phone
    @msg = message.messages
    mail(to: @phone, 
    subject: "RECALL",
   )
  end
  
  def message_confirm(user,message)
    @msg = message
    @user = user
    mail :to => user.email, :subject => "CONFIRM RECALL"
  end
  
   def message_confirm_text(user,message,phone)
     @msg = message
    @user = user
    mail :to => phone, :subject => "CONFIRM RECALL"
  end
  
  
  
  
  
  
  
  
  
  
  
  end
