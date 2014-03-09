class CountdownUsers::ConfirmationsController < Devise::ConfirmationsController

  def create
    self.resource = CountdownUser.create(:email => params[resource_name][:email]) # resource_class.send_confirmation_instructions(params[resource_name])
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with(resource)
      # respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  def show
    self.resource = CountdownUser.find_by(confirmation_token: params[:confirmation_token])

    unless self.resource.nil?
      self.resource.confirm!
      # self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      if resource.errors.empty?
        set_flash_message(:notice, :confirmed) if is_flashing_format?
        respond_with_navigational(resource){redirect_to confirmation_path(resource_name)}
        # respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
      else
        respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
      end
    end
  end
end
