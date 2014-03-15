class CountdownUsers::ConfirmationsController < Devise::ConfirmationsController
  def create
    countdown_user = CountdownUser.find_by(countdown_user_params)

    if countdown_user.nil?
      countdown_user = CountdownUser.new(countdown_user_params)
      if countdown_user.save
        set_flash_message :notice, :send_instructions
      else
        set_flash_message :error, :invalid_email, school: countdown_user.school.name if countdown_user.school
      end
    else
      if countdown_user.confirmed?
        set_flash_message :notice, :already_confirmed
      else
        set_flash_message :notice, :confirmation_already_sent
      end
    end

    if countdown_user.school
      redirect_to countdown_path(countdown_user.school.name)
    else
      redirect_to :root
    end
  end

  def show
    confirmation_token = params[:confirmation_token]
    countdown_user = CountdownUser.find_by(confirmation_token: confirmation_token)

    if countdown_user.nil?
      redirect_to :root
    else
      if countdown_user.confirmed?
        set_flash_message :alert, :already_confirmed
      else
        countdown_user.confirm!
        countdown_user.update(confirmation_token: confirmation_token)

        countdown_user.school.increment!(:signups)
        set_flash_message :notice, :confirmed
      end
      redirect_to countdown_path(countdown_user.school.name)
    end
  end

  private
    def countdown_user_params
      params.require(:countdown_user).permit(:email, :school_id)
    end
end
