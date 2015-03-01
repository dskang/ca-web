class DeviseMailerPreview < ActionMailer::Preview

  # Previews accessible from http://localhost:3000/rails/mailers/
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(sample_user, "test")
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(sample_user, "test")
  end

  protected

  def sample_user
    User.new(email: "hi@princeton.edu", password: "password")
  end

end
