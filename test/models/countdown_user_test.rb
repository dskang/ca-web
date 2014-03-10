require 'test_helper'

class CountdownUserTest < ActiveSupport::TestCase
  test "email validation" do
    assert_not CountdownUser.new(email:"foo@bar.com").valid?
    assert_not CountdownUser.new(email:"test@duke.edu").valid?
    assert_not CountdownUser.new(email:"hi").valid?
    assert CountdownUser.new(email:"test@harvard.edu").valid?
    assert CountdownUser.new(email:"test@princeton.edu").valid?
    assert CountdownUser.new(email:"test@upenn.edu").valid?
    assert CountdownUser.new(email:"test@columbia.edu").valid?
    assert CountdownUser.new(email:"test@cornell.edu").valid?
    assert CountdownUser.new(email:"test@dartmouth.edu").valid?
    assert CountdownUser.new(email:"test@yale.edu").valid?
    assert CountdownUser.new(email:"test@brown.edu").valid?
  end
end
