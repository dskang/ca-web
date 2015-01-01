class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
    super do |user|
      if user.confirmed?
        user.school.increment!(:signups)
      end
    end
  end

  protected

  def after_confirmation_path_for(resource_name, resource)
    share_path(school: resource.school)
  end
end
