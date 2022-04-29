import * as WebAuthnJSON from "@github/webauthn-json"

function getCSRFToken() {
  let CSRFSelector = document.querySelector('meta[name="csrf-token"]')
  if (CSRFSelector) {
    return CSRFSelector.getAttribute("content")
  } else {
    return null
  }
}

function callback(url, body) {
  fetch(url, {
    method: "POST",
    body: JSON.stringify(body),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-CSRF-Token": getCSRFToken()
    },
    credentials: 'same-origin'
  }).then(function(response) {
    response.json().then(function(result) {
      window.location.replace(result.redirect_path)
    })
  }).catch(function(error) {
    if (error.response.status === 422) {
      const errorMessage = document.getElementById('security-key-error-message')
      errorMessage.classList.remove('hidden');
      console.error(error.response.data.error)
    } else {
      console.error(error)
    }
  })
}

function create(nickname, credentialOptions) {
  WebAuthnJSON.create({ "publicKey": credentialOptions }).then(function(credential) {
    let params = { "credential": credential, "nickname": nickname }
    callback("/settings/security_keys", params)
  }).catch(function(error) {
    const errorMessage = document.getElementById('security-key-error-message')
    errorMessage.classList.remove('hidden')
    console.error(error)
  })
}

function get(credentialOptions) {
  WebAuthnJSON.get({ "publicKey": credentialOptions }).then(function(credential) {
    let params = { "user": { "credential": credential } }
    callback("login", params)
  }).catch(function(error) {
    const errorMessage = document.getElementById('security-key-error-message')
    errorMessage.classList.remove('hidden')
    console.error(error)
  })
}

export { create, get }
