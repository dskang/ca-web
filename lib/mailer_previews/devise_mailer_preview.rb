class DeviseMailerPreview < ActionMailer::Preview

  # Accessible from http://www.ca.local:3000/rails/mailers/devise_mailer/confirmation_instructions
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(User.first, "test")
  end

  # Accessible from http://www.ca.local:3000/rails/mailers/devise_mailer/reset_password_instructions
  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.first, "test")
  end

end
