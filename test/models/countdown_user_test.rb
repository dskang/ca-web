require 'test_helper'

class CountdownUserTest < ActiveSupport::TestCase
  test "should not save countdown user without school" do
    countdown_user = CountdownUser.new(email: "hi@princeton.edu")
    assert !countdown_user.save
  end

  test "should not save mismatching email for school" do
    princeton = School.find_by(name: "princeton")
    assert !princeton.nil?

    user1 = CountdownUser.new(email: "hi@princeton.edu", school_id: princeton.id)
    assert user1.save

    user2 = CountdownUser.new(email: "hi@harvard.edu", school_id: princeton.id)
    assert !user2.save
  end
end
