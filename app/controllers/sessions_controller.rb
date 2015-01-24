class SessionsController < Devise::SessionsController

  def create
    super do |user|
      unless user.confirmed?
        set_flash_message(:notice, :signed_in_but_unconfirmed) if is_flashing_format?
      end
    end
  end

end
