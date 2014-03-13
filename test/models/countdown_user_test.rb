require 'test_helper'

class CountdownUserTest < ActiveSupport::TestCase
  test "should not save countdown user without school" do
    countdown_user = CountdownUser.new(email:"aktwo@princeton.edu")
    assert_not countdown_user.save
  end
end
