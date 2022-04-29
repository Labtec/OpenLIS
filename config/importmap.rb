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
pin "@github/webauthn-json", to: "@github--webauthn-json.js" # @1.0.1
pin_all_from "app/javascript/webauthn", under: "webauthn"
