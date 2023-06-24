import { Controller } from "@hotwired/stimulus"
import { supported } from "@github/webauthn-json"
import { get } from "@rails/request.js"
import * as Credential from "webauthn/credential"

export default class extends Controller {
  static targets = [ "nickname", "submitButton", "webauthnMessage" ]
  static values = { callbackUrl: String }

  connect() {
    if (!supported()) {
      this.submitButtonTarget.disabled = true
      if (this.hasWebauthnMessageTarget) {
        this.webauthnMessageTarget.hidden = true
      }
    }
  }

  async authenticate(event) {
    event.preventDefault()

    if (this.hasCallbackUrlValue) {
      const response = await get(this.callbackUrlValue)
      if (response.ok) {
        response.json.then(credentialOptions => Credential.get(credentialOptions))
      }
    }
  }

  async register(event) {
    event.preventDefault()

    if (this.hasNicknameTarget && this.nicknameTarget.value) {
      let nickname = this.nicknameTarget.value

      if (this.hasCallbackUrlValue) {
        const response = await get(this.callbackUrlValue)
        if (response.ok) {
          response.json.then(credentialOptions => Credential.create(nickname, credentialOptions))
        }
      }
    } else {
      this.nicknameTarget.focus()
    }
  }
}
