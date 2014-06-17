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
  end
