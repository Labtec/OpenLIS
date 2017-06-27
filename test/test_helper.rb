# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'bcrypt'

class ActiveSupport::TestCase
  fixtures :all
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Warden::Test::Helpers

  Warden.test_mode!

  fixtures :users

  def select_date(date, options = {})
    raise ArgumentError, 'from is a required option' if options[:from].blank?
    field = options[:from].to_s
    select date.year.to_s,               from: "#{field}_1i"
    select Date::MONTHNAMES[date.month], from: "#{field}_2i"
    select date.day.to_s,                from: "#{field}_3i"
  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end
