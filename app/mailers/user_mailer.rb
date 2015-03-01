class UserMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'
  layout 'email'

  def confirmation_instructions(record, token, opts={})
    attachments.inline['confirm_account'] = {
      data: File.read("#{Rails.root.to_s + '/app/assets/images/confirm_account.png'}"),
      mime_type: "image/png"
    }
    super
  end

  def reset_password_instructions(record, token, opts={})
    attachments.inline['reset_password'] = {
      data: File.read("#{Rails.root.to_s + '/app/assets/images/reset_password.png'}"),
      mime_type: "image/png"
    }
    super
  end
end
