# Pin npm packages by running ./bin/importmap

# Application
pin "application", preload: true
pin_all_from "app/javascript/old", under: "old"

# Hotwire
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

# WebAuthn
pin "@github/webauthn-json", to: "@github--webauthn-json.js" # @2.0.1
pin_all_from "app/javascript/webauthn", under: "webauthn"
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.6

# XXXJL TODO
# Notes:
#pin "@github/markdown-toolbar-element"
# Doctors:
#pin "@github/combobox-nav"
#@github/remote-input-element
# Lab Tests:
#pin "@github/task-lists-element"
# Navbar:
#pin "@github/tab-container-element"
# Localized DateTime
#pin "@github/time-elements"

# Login page
pin "@rails/ujs", to: "@rails--ujs.js" # @7.0.3-1
