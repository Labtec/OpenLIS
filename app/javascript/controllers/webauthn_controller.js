import { Controller } from "@hotwired/stimulus"
import * as WebAuthnJSON from "@github/webauthn-json"
import * as Credential from "webauthn/credential"

export default class extends Controller {
  static targets = [ "nickname", "submitButton", "webauthnMessage", "webauthnForm" ]

  connect() {
    if (!WebAuthnJSON.supported()) {
      this.submitButtonTarget.disabled = true
      if (this.hasWebauthnMessageTarget) {
        this.webauthnMessageTarget.hidden = true
      }
    }
  }

  authenticate(event) {
    event.preventDefault()

    if (this.hasWebauthnFormTarget) {
      fetch("/auth/sessions/security_key_options").then(function(response) {
        response.json().then(function(credentialOptions) {
          Credential.get(credentialOptions)
        })
      })
    }
  }

  register(event) {
    event.preventDefault()

    if (this.hasNicknameTarget && this.nicknameTarget.value) {
      let nickname = this.nicknameTarget.value

      fetch("/settings/security_keys/options").then(function(response) {
        response.json().then(function(credentialOptions) {
          Credential.create(nickname, credentialOptions)
        })
      })
    } else {
      this.nicknameTarget.focus()
    }
  }
}
