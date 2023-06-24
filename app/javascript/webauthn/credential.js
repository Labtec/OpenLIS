import * as WebAuthnJSON from "@github/webauthn-json"
import { post } from "@rails/request.js"

async function callback(url, body) {
  const response = await post(url, { body: JSON.stringify(body) })
  if (response.ok) {
    response.json.then(result => {
      window.location.replace(result.redirect_path)
    })
  } else {
    if (response.statusCode === 422) {
      const errorMessage = document.getElementById("security-key-error-message")
      errorMessage.classList.remove("hidden")
    } else {
      console.error(response)
    }
  }
}

function create(nickname, credentialOptions) {
  WebAuthnJSON.create({ "publicKey": credentialOptions }).then(function(credential) {
    let params = { "credential": credential, "nickname": nickname }
    callback("/settings/security_keys", params)
  }).catch(function(error) {
    const errorMessage = document.getElementById("security-key-error-message")
    errorMessage.classList.remove("hidden")
    console.error(error)
  })
}

function get(credentialOptions) {
  WebAuthnJSON.get({ "publicKey": credentialOptions }).then(function(credential) {
    let params = { "user": { "credential": credential } }
    callback("login", params)
  }).catch(function(error) {
    const errorMessage = document.getElementById("security-key-error-message")
    errorMessage.classList.remove("hidden")
    console.error(error)
  })
}

export { create, get }
