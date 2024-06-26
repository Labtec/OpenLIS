# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.3.0'

gem 'rails', '7.1.3.4'

gem 'aasm'
gem 'acts_as_list'
gem 'auto_strip_attributes'
gem 'barby'
gem 'bcrypt'
gem 'bootsnap', require: false
gem 'commonmarker'
gem 'csv'
gem 'dalli'
gem 'devise'
gem 'drb'
gem 'ed25519'
gem 'fast_blank'
gem 'fhir_models'
gem 'health_cards', github: 'jlduran/health_cards', branch: 'development'
gem 'importmap-rails'
gem 'jbuilder'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'mutex_m'
gem 'nokogiri'
gem 'pdf-core', github: 'Labtec/pdf-core', branch: 'pdfa-1b'
gem 'pg'
gem 'pg_search'
gem 'phonelib'
gem 'prawn'
gem 'prawn-svg'
gem 'prawn-table'
gem 'puma', '>= 6.0'
gem 'rails-html-sanitizer'
gem 'rails-i18n'
gem 'sassc-rails' # TODO
gem 'semacode', github: 'Labtec/semacode', branch: 'barcodes'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'webauthn'

group :development, :test do
  gem 'capistrano3-puma'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'bcrypt_pbkdf'
  gem 'brakeman', require: false
  gem 'flamegraph', require: false
  gem 'i18n-tasks', require: false
  gem 'rack-mini-profiler', require: false
  gem 'rb-kqueue'
  gem 'stackprof'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
