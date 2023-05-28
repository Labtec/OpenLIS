# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.2.0"

gem "rails", "7.0.4.3"

gem "aasm"
gem "acts_as_list"
gem "auto_strip_attributes"
gem "barby"
gem "bcrypt"
gem "bootsnap", require: false
gem "coffee-rails" # TODO
gem "commonmarker"
gem "dalli"
gem "devise"
gem "ed25519"
gem "fast_blank"
gem "fhir_models"
gem "importmap-rails"
gem "jbuilder"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "kaminari"
gem "nokogiri"
gem "pdf-core", github: "Labtec/pdf-core", branch: "pdfa-1b"
gem "pg"
gem "pg_search"
gem "phonelib"
gem "prawn"
gem "prawn-svg"
gem "prawn-table"
gem "puma"
gem "rails-html-sanitizer"
gem "rails-i18n"
gem "sassc-rails"
gem "semacode", github: "Labtec/semacode", branch: "barcodes"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "webauthn"

gem "matrix"
gem "irb"
gem "reline"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "capistrano3-puma"
  gem "capistrano-rails"
  gem "capistrano-rbenv"
  gem "capistrano-bundler"
end

group :development do
  gem "brakeman", require: false
  gem "flamegraph", require: false
  gem "rack-mini-profiler", require: false
  gem "rb-kqueue"
  gem "stackprof"
  gem "web-console"
  gem "bcrypt_pbkdf"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
