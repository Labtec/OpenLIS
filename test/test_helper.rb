# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'capybara/rails'
require 'bcrypt'

module ActiveSupport
  class TestCase
    include Capybara::DSL
    include Warden::Test::Helpers

    Warden.test_mode!

    parallelize(workers: :number_of_processors)

    fixtures :all

    def select_date(date, options = {})
      raise ArgumentError, 'from is a required option' if options[:from].blank?

      field = options[:from].to_s
      select date.year.to_s,               from: "#{field}_1i"
      select Date::MONTHNAMES[date.month], from: "#{field}_2i"
      select date.day.to_s,                from: "#{field}_3i"
    end
  end
end

module ActionController
  class TestCase
    include Devise::Test::ControllerHelpers
  end
end
