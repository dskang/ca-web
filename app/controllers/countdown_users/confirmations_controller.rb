class CountdownUsers::ConfirmationsController < Devise::ConfirmationsController

  def create
    email = params[resource_name][:email]
    countdown_user = CountdownUser.find_by(email:email)
    email_is_valid = CountdownUser.new(email:email).valid?

    unless countdown_user.nil?
      if countdown_user.confirmed?
        set_flash_message(:notice, :already_confirmed)
        redirect_to new_confirmation_path(resource_name)
      else
        set_flash_message(:notice, :confirmation_already_sent)
        redirect_to new_confirmation_path(resource_name)
      end
      self.resource = countdown_user
    else
      if email_is_valid
        self.resource = CountdownUser.create(email:email)
        set_flash_message(:notice, :send_instructions)
        yield resource if block_given?
      else
        set_flash_message(:notice, :invalid_email)
        redirect_to new_confirmation_path(resource_name)
      end
    end
  end

  def show
    self.resource = CountdownUser.find_by(confirmation_token: params[:confirmation_token])
    unless self.resource.nil?
      self.resource.confirm!
      set_flash_message(:notice, :confirmed)
    end
  end
end
