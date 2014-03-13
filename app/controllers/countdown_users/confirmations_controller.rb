class CountdownUsers::ConfirmationsController < Devise::ConfirmationsController

  def create
    email = params[resource_name][:email]
    countdown_user = CountdownUser.find_by(email:email)

    if countdown_user.nil?
      new_countdown_user = CountdownUser.create(email:email)
      new_countdown_user.set_school_id!
      if new_countdown_user.confirmation_token.nil?
        set_flash_message(:notice, :invalid_email)
        redirect_to new_confirmation_path(resource_name)
      else
        self.resource = new_countdown_user
        set_flash_message(:notice, :send_instructions)
        yield resource if block_given?
      end
    else
      if countdown_user.confirmed?
        set_flash_message(:notice, :already_confirmed)
        redirect_to new_confirmation_path(resource_name)
      else
        set_flash_message(:notice, :confirmation_already_sent)
        redirect_to new_confirmation_path(resource_name)
      end
    end
  end

  def show
    countdown_user = CountdownUser.find_by(confirmation_token: params[:confirmation_token])
    if countdown_user.nil?
      set_flash_message(:notice, :already_confirmed)
    else
      countdown_user.confirm!
      countdown_user.school.increment!(:signups)
      set_flash_message(:notice, :confirmed)
    end
  end
end
