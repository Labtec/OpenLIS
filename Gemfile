# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.0.0'

gem 'rails', '6.1.2'

gem 'aasm'
gem 'acts_as_list'
gem 'auto_strip_attributes'
gem 'barby'
gem 'bcrypt'
gem 'bootsnap'
gem 'coffee-rails'
gem 'dalli'
gem 'devise'
gem 'fast_blank'
gem 'fhir_models'
gem 'jbuilder'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'nokogiri'
gem 'pdf-core', github: 'Labtec/pdf-core', branch: 'pdfa-1b'
gem 'pg'
gem 'pg_search'
gem 'phonelib'
gem 'prawn'
gem 'prawn-svg'
gem 'prawn-table'
gem 'puma'
gem 'rails-html-sanitizer'
gem 'rails-i18n'
gem 'rexml'
gem 'sass-rails'
gem 'semacode', github: 'Labtec/semacode', branch: 'barcodes'
gem 'turbolinks'
gem 'uglifier'
gem 'webauthn'
gem 'webpacker'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capistrano3-puma'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-yarn'
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :development do
  gem 'bcrypt_pbkdf'
  gem 'brakeman', require: false
  # gem 'capistrano-maintenance'
  gem 'ed25519'
  gem 'flamegraph', require: false
  gem 'listen'
  gem 'rack-mini-profiler', require: false
  gem 'rb-kqueue'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'stackprof'
  gem 'web-console'
end
