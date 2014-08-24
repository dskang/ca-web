class Users::ConfirmationsController < Devise::ConfirmationsController
  def create
    user = User.find_by(user_params)

    if user.nil?
      user = User.new(user_params)
      if user.save
        set_flash_message :notice, :send_instructions
      else
        set_flash_message :error, :invalid_email, school: user.school.name if user.school
      end
    else
      if user.confirmed?
        set_flash_message :notice, :already_confirmed
      else
        set_flash_message :notice, :confirmation_already_sent
      end
    end

    if user.school
      redirect_to countdown_path(user.school.name)
    else
      redirect_to :root
    end
  end

  def show
    confirmation_token = params[:confirmation_token]
    user = User.find_by(confirmation_token: confirmation_token)

    if user.nil?
      redirect_to :root
    else
      if user.confirmed?
        set_flash_message :alert, :already_confirmed
      else
        user.confirm!
        user.update(confirmation_token: confirmation_token)

        user.school.increment!(:signups)
        set_flash_message :notice, :confirmed
      end
      redirect_to countdown_path(user.school.name)
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :school_id)
    end
end
