class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
    confirmation_token = params[:confirmation_token]
    user = User.find_by(confirmation_token: confirmation_token)
    if user.nil?
      redirect_to :root
    else
      school = user.school
      if user.confirmed?
        set_flash_message :alert, :already_confirmed
      else
        user.confirm!
        user.update(confirmation_token: confirmation_token)
        user.school.increment!(:signups)
        set_flash_message :notice, :confirmed
      end
      redirect_to share_path(school: school)
    end
  end

end
