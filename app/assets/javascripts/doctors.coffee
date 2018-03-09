$(document).on 'turbolinks:load', ->
  doctors = $('input#accession_doctor_name').data('doctors')

  $('input#accession_doctor_name').autocomplete
    source: (request, response) ->
      matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), 'i')
      response $.grep(doctors, (value) ->
        value = value.label or value.value or value
        matcher.test(value) or matcher.test(value.normalize('NFD').replace(/[\u0300-\u036f]/g, ""))
      )
    minLength: 2
