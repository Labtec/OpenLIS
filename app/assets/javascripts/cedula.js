async function cedulaReader() {
  try {
    const str = await navigator.clipboard.readText();
    var res = str.split("|");

    var given_name = res[1].split(" ");
    var family_name = res[2].split(" ");
    var gender = res[4];
    var dob = res[6].split("-");
    var birthdate = dob[2] + "-" + dob[1] + "-" + dob[0];
    var identifier = res[0];

    document.getElementById("patient_given_name").value = given_name.shift();
    document.getElementById("patient_middle_name").value = given_name.join(" ");
    document.getElementById("patient_family_name").value = family_name.shift();
    document.getElementById("patient_family_name2").value = family_name.join(" ");
    document.getElementById("patient_gender").value = gender;
    document.getElementById("search").value = identifier;
    document.getElementById("patient_identifier").value = identifier;
    var mobile = document.getElementById("patient_birthdate");
    if (typeof(mobile) != 'undefined' && mobile != null) {
      document.getElementById("patient_birthdate").value = birthdate;
    } else {
      document.getElementById("patient_birthdate_1i").value = dob[2];
      document.getElementById("patient_birthdate_2i").selectedIndex = dob[1];
      document.getElementById("patient_birthdate_3i").selectedIndex = dob[0];
    }
  } catch (err) {
    console.error('Error: ', err);
  }
  event.preventDefault();
}
