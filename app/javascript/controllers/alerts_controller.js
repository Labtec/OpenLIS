import { Controller } from "@hotwired/stimulus"
import * as WebAuthnJSON from "@github/webauthn-json";

export default class extends Controller {
  static targets = [ "unsupportedBrowserMessage" ]

  connect() {
    if (!WebAuthnJSON.supported()) {
      this.unsupportedBrowserMessageTarget.hidden = false
    }
  }
}
