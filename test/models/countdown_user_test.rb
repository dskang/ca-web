require 'test_helper'

class CountdownUserTest < ActiveSupport::TestCase
  test "should not save countdown user without school" do
    countdown_user = CountdownUser.new(email: "hi@princeton.edu")
    assert_not countdown_user.save
  end

  test "should not save with non-ivy school" do
    school = School.find_by(name: "duke")
    assert school.nil?

    user = CountdownUser.new(email: "hi@duke.edu")
    user.school = school
    assert_not user.save
  end

  test "should not save mismatching email for school" do
    princeton = School.find_by(name: "princeton")
    assert_not princeton.nil?

    user1 = CountdownUser.new(email: "hi@princeton.edu", school_id: princeton.id)
    assert user1.save

    user2 = CountdownUser.new(email: "hi@harvard.edu", school_id: princeton.id)
    assert_not user2.save

    user3 = CountdownUser.new(email: "hi@duke.edu", school_id: princeton.id)
    assert_not user3.save

    user4 = CountdownUser.new(email: "foo@bar.com", school_id: princeton.id)
    assert_not user4.save
  end
end
