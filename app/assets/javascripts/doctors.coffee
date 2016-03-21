$(document).on 'ready page:load', ->
  accentMap =
    'Á': 'a'
    'á': 'a'
    'É': 'e'
    'é': 'e'
    'Í': 'i'
    'í': 'i'
    'Ó': 'o'
    'ó': 'o'
    'Ú': 'u'
    'Ü': 'u'
    'ú': 'u'
    'ü': 'u'
    'Ñ': 'n'
    'ñ': 'n'

  doctors = $('input#accession_doctor_name').data('doctors')

  normalize = (term) ->
    ret = ''
    i = 0
    while i < term.length
      ret += accentMap[term.charAt(i)] or term.charAt(i)
      i++
    ret

  $('input#accession_doctor_name').autocomplete
    source: (request, response) ->
      matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), 'i')
      response $.grep(doctors, (value) ->
        value = value.label or value.value or value
        matcher.test(value) or matcher.test(normalize(value))
      )
    minLength: 2
