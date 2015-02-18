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

  test "should accept non-alumni subdomains of all ivy league schools" do
    ivies = %w(princeton harvard yale brown upenn columbia dartmouth cornell)
    ivies.each do |ivy|
      @user.email = "hi@subdomain.#{ivy}.edu"
      assert @user.save
    end
  end

  test "should not accept known alumni subdomains" do
    alumni_subdomains = %w(alumni post aya cca)
    alumni_subdomains.each do |subdomain|
      @user.email = "hi@#{subdomain}.princeton.edu"
      assert_not @user.save
      assert_equal [:email], @user.errors.keys
    end
  end

  test "should reject non-ivy schools" do
    @user.email = "hi@duke.edu"
    assert_not @user.save
    assert_equal [:school], @user.errors.keys
  end

  test "should reject invalid emails" do
    @user.email = 'abcd@efg'
    assert_not @user.save
    assert_equal [:email], @user.errors.keys
  end

  test "should require password for unsaved users" do
    user = User.new(email: 'hi@princeton.edu')
    assert_not user.save
    assert_equal [:password], user.errors.keys
  end

  test "should not require password field for saved users" do
    @user.password = nil
    assert @user.save
  end

  test "should reject multiple users with same email" do
    user = User.new(email: 'hi@princeton.edu', password: 'asdf')
    assert user.save
    user2 = User.new(email: 'hi@princeton.edu', password: 'fdsa')
    assert_not user2.save
    assert_equal [:email], user2.errors.keys
  end
end
