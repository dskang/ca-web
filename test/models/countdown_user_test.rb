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

    user3 = CountdownUser.new(email: "hi@duke.edu", school_id: princeton.id)
    assert !user3.save

    user4 = CountdownUser.new(email: "foo@bar.com", school_id: princeton.id)
    assert !user4.save
  end
end
