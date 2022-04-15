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
pin "axios", to: "https://ga.jspm.io/npm:axios@0.26.1/index.js"
pin "#lib/adapters/http.js", to: "https://ga.jspm.io/npm:axios@0.26.1/lib/adapters/xhr.js"
pin "@github/webauthn-json", to: "@github--webauthn-json.js" # @1.0.1
pin "regenerator-runtime/runtime", to: "regenerator-runtime--runtime.js" # @0.13.9
pin_all_from "app/javascript/webauthn", under: "webauthn"
