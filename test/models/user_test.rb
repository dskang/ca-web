require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:dk)
  end

  test "should save fixture without errors" do
    assert @user.save
  end

  test "should not save user if email does not match school" do
    assert_equal @user.school.name, 'princeton'
    @user.email = 'dskang@harvard.edu'
    assert_not @user.save
  end
end
