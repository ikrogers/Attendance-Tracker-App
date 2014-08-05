class ConfirmationsController < Devise::ConfirmationsController
  layout 'application'
  
  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      if mobile_device?
          respond_with_navigational(resource){ redirect_to unauthenticated_root_path }
        else
          respond_with_navigational(resource){ redirect_to unauthenticated_root_path }
        end
    else
      set_flash_message(:alert, 'Something went wrong! Resend confirmation link here.') if is_flashing_format?
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end
end