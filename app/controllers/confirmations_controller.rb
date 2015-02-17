class ConfirmationsController < Devise::ConfirmationsController

  def show
    super do |resource|
      unless resource.errors.empty?
        set_flash_message :alert, :already_confirmed
        redirect_to root_path
        return
      end
    end
  end

  protected

  def after_resending_confirmation_instructions_path_for(resource_name)
    root_path
  end

  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(resource_name)
      signed_in_root_path(resource)
    else
      root_path
    end
  end

end
