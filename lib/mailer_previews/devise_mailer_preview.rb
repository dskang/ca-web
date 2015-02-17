class DeviseMailerPreview < ActionMailer::Preview

  # Previews accessible from http://localhost:3000/rails/mailers/
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(User.first, "test")
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.first, "test")
  end

end
