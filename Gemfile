# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.4'

gem 'rails', '5.2.3'

gem 'acts_as_list'
gem 'auto_strip_attributes'
gem 'bcrypt'
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
gem 'puma', '4.0.1'
gem 'rails-html-sanitizer'
gem 'rails-i18n', '~> 5'
gem 'sassc-rails'
gem 'sassc', github: 'Labtec/sassc-ruby', submodules: true, branch: 'no-lto'
gem 'turbolinks', '~> 5'
gem 'uglifier'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-yarn'
  gem 'capistrano3-puma'
  gem 'capybara'
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

  require 'rbconfig'
  gem 'rb-kqueue' if RbConfig::CONFIG['target_os'] =~ /(?i-mx:bsd|dragonfly)/
end
