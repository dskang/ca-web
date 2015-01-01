require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:dk)
  end

  test "should save fixture without errors" do
    assert @user.save
  end

end
