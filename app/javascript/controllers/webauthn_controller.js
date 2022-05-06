import { Controller } from "@hotwired/stimulus"
import { supported } from "@github/webauthn-json"
import * as Credential from "webauthn/credential"

export default class extends Controller {
  static targets = [ "nickname", "submitButton", "webauthnMessage", "webauthnForm" ]
  static values = { callbackUrl: String }

  connect() {
    if (!supported()) {
      this.submitButtonTarget.disabled = true
      if (this.hasWebauthnMessageTarget) {
        this.webauthnMessageTarget.hidden = true
      }
    }
  }

  authenticate(event) {
    event.preventDefault()

    if (this.hasWebauthnFormTarget) {
      fetch(this.callbackUrlValue).then(response => {
        response.json().then(credentialOptions => Credential.get(credentialOptions))
      })
    }
  }

  register(event) {
    event.preventDefault()

    if (this.hasNicknameTarget && this.nicknameTarget.value) {
      let nickname = this.nicknameTarget.value

      fetch(this.callbackUrlValue).then(response => {
        response.json().then(credentialOptions => Credential.create(nickname, credentialOptions))
      })
    } else {
      this.nicknameTarget.focus()
    }
  }
}
