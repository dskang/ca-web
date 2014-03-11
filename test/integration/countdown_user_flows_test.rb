require 'test_helper'

class CountdownUserFlowsTest < ActionDispatch::IntegrationTest

  test "new school email should confirm properly, create a new school object and increment its signups" do 

    # Initialize variables
    new_email = "foo@harvard.edu"

    # Check pre-conditions
    assert_nil CountdownUser.find_by(email:new_email)
    assert_nil School.find_by(name:"harvard")

    # Confirm email for new school
    # FIXME: use URL helper here
    # :countdown_user_confirmation_url, :new_countdown_user_confirmation_path, :new_countdown_user_confirmation_url,
    post countdown_user_confirmation_path(:countdown_user), countdown_user:{email: new_email}
    assert_not_nil CountdownUser.find_by(email:new_email)
    assert_not CountdownUser.find_by(email:new_email).confirmed?
    assert_not_nil CountdownUser.find_by(email:new_email).school_id

    # Check confirmation email message
    email_message = ActionMailer::Base.deliveries.last
    assert_not_nil email_message
    regex = /<a href="http:\/\/localhost:3000(?<url>.*)\?confirmation_token=(?<token>.*)">/
    email_path = regex.match(email_message.to_s)[:url]
    token = regex.match(email_message.to_s)[:token]
    assert_equal token, CountdownUser.find_by(email:new_email).confirmation_token

    # Visit confirmation link in the email
    get email_path, confirmation_token: token
    assert_response :success

    # Check that the school was created
    assert_not_nil School.find_by(name:"harvard")

    # Check that the user was confirmed
    assert_not_nil CountdownUser.find_by(email:new_email)
    assert CountdownUser.find_by(email:new_email).confirmed?
    assert_equal CountdownUser.find_by(email:new_email).school_id, School.find_by(name:"harvard").id

    # Check that the signups counter was incremented
    assert_equal 1, School.find_by(name:"harvard").signups

  end

  test "existing school email should confirm properly and increment signups" do

    # Initialize variables 
    new_email = "randomly_long_email@princeton.edu"

    # Check pre-conditions
    assert_not_nil School.find_by(name:"princeton")
    assert_nil CountdownUser.find_by(email:new_email)
    existing_signups = School.find_by(name:"princeton").signups

    # Confirm email for existing school
    post countdown_user_confirmation_path(:countdown_user), countdown_user:{email:new_email}
    assert_not_nil CountdownUser.find_by(email:new_email)
    assert_not CountdownUser.find_by(email:new_email).confirmed?
    assert_not_nil CountdownUser.find_by(email:new_email).school_id

    # Check confirmation email message
    email_message = ActionMailer::Base.deliveries.last
    assert_not_nil email_message
    regex = /<a href="http:\/\/localhost:3000(?<url>.*)\?confirmation_token=(?<token>.*)">/
    email_path = regex.match(email_message.to_s)[:url]
    token = regex.match(email_message.to_s)[:token]
    assert_equal token, CountdownUser.find_by(email:new_email).confirmation_token

    # Visit confirmation link in the email
    get email_path, confirmation_token: token
    assert_response :success

    # Check that the user was confirmed
    assert_not_nil CountdownUser.find_by(email:new_email)
    assert CountdownUser.find_by(email:new_email).confirmed?
    assert_equal CountdownUser.find_by(email:new_email).school_id, School.find_by(name:"princeton").id

    # Check that the signups counter was incremented
    assert_equal existing_signups + 1, School.find_by(name:"princeton").signups

  end

  test "invalid email should result in no database save and error message" do

    # Initialize variables
    invalid_email = "foo@bar.com"

    assert_nil CountdownUser.find_by(email:invalid_email)
    post countdown_user_confirmation_path(:countdown_user), countdown_user:{email:invalid_email}
    assert_nil CountdownUser.find_by(email:invalid_email)
    assert_equal flash[:notice], "Please enter a valid Ivy League .edu email address!"

  end

  test "duplicate form re-submission should result in only one email sent and error message" do

    # Initialize variables
    duplicate_email = "duplicate_email@princeton.edu"
    existing_inbox_size = ActionMailer::Base.deliveries.size

    # Send form twice
    post countdown_user_confirmation_path(:countdown_user), countdown_user:{email:duplicate_email}
    assert_equal existing_inbox_size + 1, ActionMailer::Base.deliveries.size

    post countdown_user_confirmation_path(:countdown_user), countdown_user:{email:duplicate_email}
    assert_equal existing_inbox_size + 1, ActionMailer::Base.deliveries.size
    assert_equal flash[:notice], "We've already sent a confirmation link to this email address. Please check your email!"

  end

  test "duplicate click from the email should result in a single sign-up increment and error message" do

    # Initialize variables
    many_click_email = "many_click_email@princeton.edu"

    # Submit email
    post countdown_user_confirmation_path(:countdown_user), countdown_user:{email:many_click_email}
    assert_not_nil School.find_by(name:"princeton")
    existing_signups = School.find_by(name:"princeton").signups

    # Parse confirmation email message
    email_message = ActionMailer::Base.deliveries.last
    regex = /<a href="http:\/\/localhost:3000(?<url>.*)\?confirmation_token=(?<token>.*)">/
    email_path = regex.match(email_message.to_s)[:url]
    token = regex.match(email_message.to_s)[:token]

    # Visit confirmation link in the email
    get email_path, confirmation_token: token
    assert_response :success

    # Check that signups have been incremented
    assert_equal existing_signups + 1, School.find_by(name:"princeton").signups

    # Visit confirmation link a second time
    get email_path, confirmation_token: token
    assert_response :success
    assert_equal flash[:notice], "Nice try, but this email address has already been confirmed!"
    assert_equal existing_signups + 1, School.find_by(name:"princeton").signups

  end

end
