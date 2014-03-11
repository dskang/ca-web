class CountdownUsers::ConfirmationsController < Devise::ConfirmationsController

  def create
    email = params[resource_name][:email]
    countdown_user = CountdownUser.find_by(email:email)

    if countdown_user.nil?
      new_countdown_user = CountdownUser.create(email:email)
      new_countdown_user.set_school_id!
      if new_countdown_user.confirmation_token.nil?
        set_flash_message(:alert, :invalid_email)
        redirect_to :back
      else
        self.resource = new_countdown_user
        set_flash_message(:notice, :send_instructions)
        yield resource if block_given?
        redirect_to :back
      end
    else
      if countdown_user.confirmed?
        set_flash_message(:alert, :already_confirmed)
        redirect_to :back
      else
        set_flash_message(:alert, :confirmation_already_sent)
        redirect_to :back
      end
    end
  end

  # FIXME: ADD REDIRECTS HERE
  def show
    countdown_user = CountdownUser.find_by(confirmation_token: params[:confirmation_token])
    if countdown_user.nil?
      set_flash_message(:alert, :already_confirmed)
    else
      countdown_user.confirm!
      countdown_user.school.increment!(:signups)
      set_flash_message(:notice, :confirmed)
    end
  end
end
