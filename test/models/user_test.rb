require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:dk)
  end

  test "should save fixture without errors" do
    assert @user.save
  end

  # test "should not save user without email" do
  #
  #   assert_not user.save
  # end
  #
  # test "should save user with ivy school" do
  #   schools = %w(princeton harvard yale brown upenn columbia dartmouth cornell)
  #   schools.each do |school|
  #     s = School.find_by(name: school)
  #     assert_not s.nil?
  #
  #     user = User.new(email: "hi@#{school}.edu")
  #     assert user.save
  #   end
  # end
  #
  # test "should not save user with non-ivy school" do
  #   school = School.find_by(name: "duke")
  #   assert school.nil?
  #
  #   user = User.new(email: "hi@duke.edu")
  #   assert_not user.save
  # end
end
