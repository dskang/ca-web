require 'test_helper'

class FailedSignupTest < ActiveSupport::TestCase

  test "should create new FailedSignup when someone with a non-ivy email address tries to register" do
    non_ivy_user = User.new(email: "hi@nonivy.edu")
    non_ivy_user.save
    assert_not_nil FailedSignup.find_by(email: non_ivy_user.email)
  end

  test "should not create new FailedSignup when someone with an ivy email address tries to register" do
    ivy_user = User.new(email: "hi@princeton.edu")
    ivy_user.save
    assert_nil FailedSignup.find_by(email: ivy_user.email)
  end

end
