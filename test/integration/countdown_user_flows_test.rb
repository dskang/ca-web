require 'test_helper'

class CountdownUserFlowsTest < ActionDispatch::IntegrationTest

  def setup
    @headers = {}
    @headers["HTTP_REFERER"] = countdown_url("princeton")
  end

  test "new school email should confirm properly, create a new school object and increment its signups" do 
    # Initialize variables
    @headers["HTTP_REFERER"] = countdown_url("harvard")
    school = School.find_by(name: "harvard")
    email = "foo@harvard.edu"

    # Check pre-conditions
    assert_nil CountdownUser.find_by(email: email)
    assert_not_nil school
    existing_signups = school.signups

    # Confirm email for school
    post_via_redirect countdown_user_confirmation_path, { countdown_user: { email: email, school_id: school.id } }, @headers
    countdown_user = CountdownUser.find_by(email: email)
    assert_not_nil countdown_user
    assert_not countdown_user.confirmed?
    assert_equal countdown_user_message(:send_instructions), flash[:notice]
    assert_equal countdown_path("harvard"), path

    # Check confirmation email message
    email_message = ActionMailer::Base.deliveries.last
    assert_not_nil email_message
    regex = /<a href="http:\/\/localhost:3000(?<url>.*)\?confirmation_token=(?<token>.*)">/
    match = regex.match(email_message.to_s)
    url, token = match[:url], match[:token]
    assert_equal token, countdown_user.confirmation_token

    # Visit confirmation link in the email
    get_via_redirect url, confirmation_token: token
    assert_response :success
    assert_equal countdown_user_message(:confirmed), flash[:notice]
    assert_equal countdown_path("harvard"), path

    # Check that the user was confirmed
    countdown_user.reload
    assert countdown_user.confirmed?

    # Check that the signups counter was incremented
    school.reload
    assert_equal existing_signups + 1, school.signups
  end

  test "invalid email should result in no database save and error message" do
    # Initialize variables
    email = "foo@bar.com"
    school = School.find_by(name: "princeton")

    assert_nil CountdownUser.find_by(email: email)
    post_via_redirect countdown_user_confirmation_path, { countdown_user: { email: email, school_id: school.id } }, @headers
    assert_nil CountdownUser.find_by(email: email)
    assert_equal countdown_user_message(:invalid_email, school: "princeton"), flash[:error]
    assert_equal countdown_path("princeton"), path
  end

  test "duplicate form re-submission should result in only one email sent and error message" do
    # Initialize variables
    email = "duplicate_email@princeton.edu"
    school = School.find_by(name: "princeton")
    existing_inbox_size = ActionMailer::Base.deliveries.size

    # Send form twice
    post_via_redirect countdown_user_confirmation_path, { countdown_user: { email: email, school_id: school.id } }, @headers
    assert_equal existing_inbox_size + 1, ActionMailer::Base.deliveries.size
    assert_equal countdown_user_message(:send_instructions), flash[:notice]
    assert_equal countdown_path("princeton"), path

    post_via_redirect countdown_user_confirmation_path, { countdown_user: { email: email, school_id: school.id } }, @headers
    assert_equal existing_inbox_size + 1, ActionMailer::Base.deliveries.size
    assert_equal countdown_user_message(:confirmation_already_sent), flash[:notice]
    assert_equal countdown_path("princeton"), path
  end

  test "duplicate click from the email should result in a single sign-up increment and error message" do
    # Initialize variables
    email = "many_click_email@princeton.edu"
    school = School.find_by(name: "princeton")
    assert_not_nil school
    existing_signups = school.signups

    # Submit email
    post_via_redirect countdown_user_confirmation_path, { countdown_user: { email: email, school_id: school.id } }, @headers

    # Parse confirmation email message
    email_message = ActionMailer::Base.deliveries.last
    assert_not_nil email_message
    regex = /<a href="http:\/\/localhost:3000(?<url>.*)\?confirmation_token=(?<token>.*)">/
    match = regex.match(email_message.to_s)
    url, token = match[:url], match[:token]

    # Visit confirmation link in the email
    get_via_redirect url, confirmation_token: token
    assert_response :success
    assert_equal countdown_user_message(:confirmed), flash[:notice]
    assert_equal countdown_path("princeton"), path

    # Check that signups have been incremented
    school.reload
    assert_equal existing_signups + 1, school.signups

    # Visit confirmation link a second time
    get_via_redirect url, confirmation_token: token
    assert_response :success
    assert_equal flash[:alert], "This email address has already been confirmed."
    assert_equal countdown_path("princeton"), path

    # Check that signups have not been incremented
    school.reload
    assert_equal existing_signups + 1, school.signups
  end

  private

    def countdown_user_message(key, options = {})
      I18n.t(:"countdown_user.#{key}", { scope: [:devise, :confirmations], default: key }.merge(options))
    end

end
