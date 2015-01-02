require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:dk)
  end

  test "should save fixture without errors" do
    assert @user.save
  end

  test "should set school from email" do
    assert_equal 'princeton', @user.school.name
    @user.email = 'hi@harvard.edu'
    assert @user.save
    assert_equal 'harvard', @user.school.name
  end

  test "should accept all ivy league schools" do
    ivies = %w(princeton harvard yale brown upenn columbia dartmouth cornell)
    ivies.each do |ivy|
      @user.email = "hi@#{ivy}.edu"
      assert @user.save
    end
  end

  test "should reject non-ivy schools" do
    @user.email = "hi@duke.edu"
    assert_not @user.save
  end

end
