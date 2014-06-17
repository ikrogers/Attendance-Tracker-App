class UserMailer < ActionMailer::Base
default from: 'RECALL@do-not-reply.com'
 
  def recall_email(user, message)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: message.messages)
  end
  end
