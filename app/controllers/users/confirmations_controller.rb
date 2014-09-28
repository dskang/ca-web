class Users::ConfirmationsController < Devise::ConfirmationsController
  def create
    user = User.find_by(user_params)

    if user.nil?
      user = User.new(user_params)
      if user.save
        set_flash_message :notice, :send_instructions
        redirect_to share_path(:school => school)
      else
        set_flash_message :error, :invalid_email, school: school
        redirect_to new_user_registration_path(:school => school)
      end
    else
      if user.confirmed?
        set_flash_message :notice, :already_confirmed
        redirect_to share_path(:school => school)
      else
        set_flash_message :notice, :confirmation_already_sent
        redirect_to share_path(:school => school)
      end
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
      redirect_to share_path(:school => school)
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :class_year, :email, :school_id)
    end

    def school
      params[:user][:school]
    end
end
