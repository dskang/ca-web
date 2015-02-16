class ConfirmationsController < Devise::ConfirmationsController

  def show
    super do |resource|
      unless resource.errors.empty?
        set_flash_message :notice, :already_confirmed
        redirect_to root_path
        return
      end
    end
  end

  protected

  def after_resending_confirmation_instructions_path_for(resource_name)
    root_path
  end

end
