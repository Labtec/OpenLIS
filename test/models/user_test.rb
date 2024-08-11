# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "presence of first name" do
    user = User.create(first_name: "")
    assert user.errors.added?(:first_name, :blank)
  end

  test "presence of initials" do
    user = User.create(initials: "")
    assert user.errors.added?(:initials, :blank)
  end

  test "presence of last name" do
    user = User.create(last_name: "")
    assert user.errors.added?(:last_name, :blank)
  end

  test "presence of username" do
    user = User.create(username: "")
    assert user.errors.added?(:username, :blank)
  end

  test "uniqueness of initials" do
    user = User.create(initials: "JD")
    assert user.errors.added?(:initials, :taken, value: "JD")
  end

  test "user contains no extra spaces" do
    user = User.create(username: "  jdoe  ",
                       first_name: "  John  ",
                       last_name: "  Doe  ",
                       initials: "  JD  ")
    assert_equal "jdoe", user.username
    assert_equal "John", user.first_name
    assert_equal "Doe", user.last_name
    assert_equal "JD", user.initials
  end

  test "no extra spaces within username" do
    user = User.create(username: "j  doe",
                       first_name: "John  John",
                       last_name: "Doe  Doe",
                       initials: "J  D")
    assert_equal "jdoe", user.username
    assert_equal "John John", user.first_name
    assert_equal "Doe Doe", user.last_name
    assert_equal "JD", user.initials
  end
end
