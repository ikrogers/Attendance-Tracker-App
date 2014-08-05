class ConfirmationsController < Devise::ConfirmationsController
  layout 'application'
  
  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      respond_to do |format|
        format.html{super}
        format.mobile {redirect_to unauthenticated_root_path, notice: 'Success'}
      end   
    else
      respond_to do |format|
        format.html{super}
        format.mobile {redirect_to unauthenticated_root_path, notice: 'Failure'}
      end
    end
  end
  
  
  def after_inactive_sign_up_path_for(resource)
    scope = Devise::Mapping.find_scope!(resource)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    context.respond_to?(:root_path) ? context.root_path : "/"
  end
end