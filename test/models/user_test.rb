require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:username)
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:initials)
  should validate_uniqueness_of(:initials)

  test 'user contains no extra spaces' do
    user = User.create(username:   '  jdoe  ',
                       first_name: '  John  ',
                       last_name:  '  Doe  ',
                       initials:   '  JD  ')
    assert_equal 'jdoe', user.username
    assert_equal 'John', user.first_name
    assert_equal 'Doe', user.last_name
    assert_equal 'JD', user.initials
  end

  test 'no extra spaces within username' do
    user = User.create(username:   'j  doe',
                       first_name: 'John  John',
                       last_name:  'Doe  Doe',
                       initials:   'J  D')
    assert_equal 'jdoe', user.username
    assert_equal 'John John', user.first_name
    assert_equal 'Doe Doe', user.last_name
    assert_equal 'JD', user.initials
  end
end
