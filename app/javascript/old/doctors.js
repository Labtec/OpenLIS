$(document).on('turbo:load', function() {
  var doctors;
  doctors = $('input#accession_doctor_name').data('doctors');
  return $('input#accession_doctor_name').autocomplete({
    source: function(request, response) {
      var matcher;
      matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), 'i');
      return response($.grep(doctors, function(value) {
        value = value.label || value.value || value;
        return matcher.test(value) || matcher.test(value.normalize('NFD').replace(/[\u0300-\u036f]/g, ""));
      }));
    },
    minLength: 2
  });
});
