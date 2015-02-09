class RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up_but_unconfirmed if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end

      if is_flashing_format?
        if resource.errors.keys.length == 1 && resource.errors.has_key?(:school)
          set_flash_message :alert, :not_an_ivy
          FailedSignup.create(email: resource.email)
        else
          messages = []
          resource.errors.keys.each do |attribute|
            messages.push(resource.errors.full_messages_for(attribute)) unless attribute == :school
          end
          flash[:alert] = messages.join('. ') + '.'
        end
      end
      redirect_to root_path
    end
  end

end
