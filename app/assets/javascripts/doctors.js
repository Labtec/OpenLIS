$(document).on("ready page:load", function() {
  $("input#accession_doctor_name").autocomplete({
    source: '/doctors.json',
    minLength: 1,
    matchContains: true
  });
});
