class ApplicationController < ActionController::Base
  include Mobylette::RespondToMobileRequests
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  def authenticate_admin_user!
  authenticate_user!
  unless current_user.admin?
    flash[:alert] = "This area is restricted to administrators only."
    redirect_to "/"
  end
end
 
def current_admin_user
  return nil if user_signed_in? && !current_user.admin?
  current_user
end
  private
   def mobile_device?
      request.user_agent =~ /Mobile|webOS/
    end
    helper_method :mobile_device?
  
end
