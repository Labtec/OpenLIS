# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

gem 'rails', '5.2.2'

gem 'acts_as_list'
gem 'auto_strip_attributes'
gem 'bcrypt', github: 'Labtec/bcrypt-ruby', branch: 'fix-freebsd-12-remove-crypt_r'
gem 'bootsnap'
gem 'coffee-rails'
gem 'dalli'
gem 'devise'
gem 'fast_blank'
gem 'jbuilder'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'pg'
gem 'pg_search'
gem 'prawn'
gem 'prawn-table'
gem 'puma'
gem 'rails-html-sanitizer'
gem 'rails-i18n', '~> 5'
gem 'sass-rails'
gem 'turbolinks', '~> 5'
gem 'uglifier'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-yarn'
  gem 'capistrano3-puma'
  gem 'capybara'
  gem 'chromedriver-helper'
  gem 'selenium-webdriver'
end

group :development do
  gem 'bcrypt_pbkdf'
  gem 'brakeman', require: false
  gem 'bullet'
  # gem 'capistrano-maintenance'
  gem 'ed25519'
  gem 'flamegraph', require: false
  gem 'listen'
  gem 'rack-mini-profiler', require: false
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'stackprof'
  gem 'web-console'
end
