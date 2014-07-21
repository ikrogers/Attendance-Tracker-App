class RegistrationsController < Devise::RegistrationsController
  
  
  
  
  before_filter :configure_permitted_parameters, :only => [:create]

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :phone, :carrier, :fname, :lname)}
    end
    
    
    
    def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :phone, :carrier, :fname, :lname)
  end
 
  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :phone, :carrier, :fname, :lname, :current_password)
  end
end