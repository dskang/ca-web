class SessionsController < Devise::SessionsController

  def create
    self.resource = warden.authenticate!(auth_options)
    if resource.confirmed?
      set_flash_message(:notice, :signed_in) if is_flashing_format?
    else
      set_flash_message(:notice, :signed_in_but_unconfirmed) if is_flashing_format?
    end
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

end
