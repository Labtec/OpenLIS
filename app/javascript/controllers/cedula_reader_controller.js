import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "scan" ]

  scan() {
    navigator.clipboard.readText().then(result => {
      let res = result.split("|")

      let givenName = res[1].split(" ")
      let familyName = res[2].split(" ")
      let gender = res[4]
      let dob = res[6].split("-")
      let birthdate = dob[2] + "-" + dob[1] + "-" + dob[0]
      let identifier = res[0]

      document.getElementById("patient_given_name").value = givenName.shift()
      document.getElementById("patient_middle_name").value = givenName.join(" ")
      document.getElementById("patient_family_name").value = familyName.shift()
      document.getElementById("patient_family_name2").value = familyName.join(" ")
      document.getElementById("patient_gender").value = gender
      document.getElementById("search").value = identifier
      document.getElementById("patient_identifier").value = identifier
      var mobile = document.getElementById("patient_birthdate")
      if (typeof(mobile) != 'undefined' && mobile != null) {
        document.getElementById("patient_birthdate").value = birthdate
      } else {
        document.getElementById("patient_birthdate_1i").value = dob[2]
        document.getElementById("patient_birthdate_2i").selectedIndex = dob[1]
        document.getElementById("patient_birthdate_3i").selectedIndex = dob[0]
      }
    })
  }
}
