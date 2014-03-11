class CountdownUsers::ConfirmationsController < Devise::ConfirmationsController

  def create
    email = params[resource_name][:email]
    from_path = params[:from_path] ? params[:from_path] : :root
    countdown_user = CountdownUser.find_by(email:email)

    if countdown_user.nil?
      new_countdown_user = CountdownUser.create(email:email)
      new_countdown_user.set_school_id!
      if new_countdown_user.confirmation_token.nil?
        set_flash_message(:alert, :invalid_email, now: true)
        redirect_to from_path
      else
        self.resource = new_countdown_user
        set_flash_message(:notice, :send_instructions, now: true)
        yield resource if block_given?
        redirect_to from_path
      end
    else
      if countdown_user.confirmed?
        redirect_to from_path
        set_flash_message(:alert, :already_confirmed, now: true)
      else
        redirect_to from_path
        set_flash_message(:alert, :confirmation_already_sent, now: true)
      end
    end
  end

  def show
    countdown_user = CountdownUser.find_by(confirmation_token: params[:confirmation_token])
    if countdown_user.nil?
      set_flash_message(:alert, :already_confirmed, now: true)
    else
      countdown_user.confirm!
      countdown_user.school.increment!(:signups)
      set_flash_message(:notice, :confirmed, now: true)
    end
  end
end
