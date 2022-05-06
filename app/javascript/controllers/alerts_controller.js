import { Controller } from "@hotwired/stimulus"
import { supported } from "@github/webauthn-json"

export default class extends Controller {
  static targets = [ "unsupportedBrowserMessage" ]

  connect() {
    if (!supported()) {
      this.unsupportedBrowserMessageTarget.hidden = false
    }
  }
}
