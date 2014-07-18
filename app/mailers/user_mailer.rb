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
  
  def message_confirm(user, message, email)
    @msg = message
    @user = user
    mail :to => email, :subject => "CONFIRM RECALL"
  end
  
   def message_confirm_text(user, message, phone)
     @msg = message
    @user = user
    mail :to => phone, :subject => "RECALL"
  end
  
  def notify(message)
    @message = message
    email = User.find_by_id(@message.users_id).email
    mail :to => email, :subject => "Recall Completed"   
  end
  
  def notify_text(message, phone)
    @message = message
    mail :to => phone, :subject => "Recall Completed"   
  end
  
  def absence_notify_text
    
  end
  
  def absence_notify(user,event)
    @user = user
    @event = event
    mail :to => user.email, :subject => "You have new "+@event+" absence"
  end
  
  def absence_notify_text(user,phone,event)
    @user = user
    @event = event
    mail :to => phone, :subject => "You have new "+@event+" absence"
  end
  
  
  
  
  
  
  
  
  
  
  
  end
